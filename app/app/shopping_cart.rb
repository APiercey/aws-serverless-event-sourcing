# frozen_string_literal: true

require_relative './events/cart_opened'
require_relative './events/item_added'

module Aggregate
  def self.included(base)
    base.class_eval do
      attr_reader :uuid
    end
  end

  def apply(event)
    fail NotImplementedError
  end

  def changes
    @changes ||= []
  end

  def clear_events
    @changes = []
  end

  def self.on(event_class, &block)
    define_method "apply_#{event_class::NAME}", &block
  end

  def apply(event)
    self.send("apply_#{event.class::NAME}", event)
  end

  private

  def enqueue(event)
    apply(event)
    changes.append(event)
  end
end

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

  on Events::CartOpened do
    @uuid = event.shopping_cart_uuid
  end

  on Events::ItemAdded do
    @items = @items.append(event.item_name)
  end

  # def apply(event)
  #   case event.class.to_s
  #   when 'Events::CartOpened'
  #     @uuid = event.shopping_cart_uuid
  #   when 'Events::ItemAdded'
  #     @items = @items.append(event.item_name)
  #   end
  # end
end
