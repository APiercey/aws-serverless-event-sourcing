# frozen_string_literal: true
require 'json'

require_relative './events/cart_opened.rb'
require_relative './shopping_cart.rb'

class ShoppingCartRepo
  def initialize(client)
    @client = client
  end

  def fetch(shopping_cart_uuid)
    shopping_cart = ShoppingCart.new

    db_item = @client.get_item({
      table_name: "ShoppingCarts",
      key: { Uuid: shopping_cart_uuid }
    })

    return nil if db_item.item.nil?

    db_item.item
      .fetch("Events", [])
      .map { |event| build_event(event) }
      .each { |event| shopping_cart.apply(event) }

    if shopping_cart.uuid.nil?
      nil
    else
      shopping_cart
    end
  end

  def store(shopping_cart)
    puts shopping_cart.inspect
    @client.update_item({
      table_name: 'ShoppingCarts',
      key: {
        Uuid: shopping_cart.uuid
      },
      update_expression: "SET #el = list_append(if_not_exists(#el, :empty_list), :new_events)",
      expression_attribute_names: {
        "#el" => "Events",
      },
      expression_attribute_values: {
        ":empty_list" => [],
        ":new_events" => shopping_cart.events.map { |event| { Name: event.class::NAME, Data: event.to_h } }
      },
    })

    shopping_cart.clear_events
    shopping_cart
  end

  private

  def build_event(raw_event)
    data = raw_event.fetch("Data")

    case raw_event["Name"]
    when "CartOpened"
      Events::CartOpened.new(data.fetch("shopping_cart_uuid"))
    when "ItemAdded"
      Events::ItemAdded.new(data.fetch("shopping_cart_uuid"), data.fetch("item_name"))
    end
  end
end
