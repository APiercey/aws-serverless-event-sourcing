# frozen_string_literal: true

require_relative './events/cart_opened'
require_relative './events/item_added'

class ShoppingCart
  attr_reader :uuid, :items
  attr_reader :events

  def initialize(uuid = nil)
    @uuid = uuid
    @items = []
    clear_events

    enqueue(Events::CartOpened.new(uuid)) unless uuid.nil?
  end

  def add_item(item_name)
    enqueue(Events::ItemAdded.new(uuid, item_name))
  end

  def apply(event)
    case event.class.to_s
    when 'Events::CartOpened'
      @uuid = event.shopping_cart_uuid
    when 'Events::ItemAdded'
      @items = @items.append(event.item_name)
    end
  end

  def clear_events
    @events = []
  end

  private

  def enqueue(event)
    apply(event)
    events.append(event)
  end
end
