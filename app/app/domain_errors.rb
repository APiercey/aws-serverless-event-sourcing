module Errors
  class ItemAlreadyAdded < StandardError
    def initialize(uuid:, item_name:)
      @msg = "#{item_name} has already been added to cart #{uuid}!"
    end
  end
end
