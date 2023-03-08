# frozen_string_literal: true

require_relative './events/cart_opened'
require_relative './events/item_added'
require_relative './shared/aggregate'

class ShoppingCart
  include Aggregate

  attr_reader :items

  def initialize(uuid = nil)
    @items = []

    enqueue(Events::CartOpened.new(uuid)) unless uuid.nil?
  end

  def add_item(item_name)
    enqueue(Events::ItemAdded.new(uuid, item_name))
  end

  on Events::CartOpened do |event|
    @uuid = event.shopping_cart_uuid
  end

  on Events::ItemAdded do |event|
    @items = @items.append(event.item_name)
  end
end
