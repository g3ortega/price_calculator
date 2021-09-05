require 'price_calculator/entities/order'
require 'price_calculator/entities/order_item'

module PriceCalculator
  class OrderProcessor
    def initialize(inventory:, product_list:)
      @inventory = inventory
      @product_list = product_list
      @order = PriceCalculator::Entities::Order.new
      @invalid_items = []
    end

    def perform
      create_order_items
      # Thinking ahead, here we might have the order processing in a transactional way,
      # for now we only care of order_items building based on requirements
      # process_order
      self
    end

    def to_s
      output = ''
      output << @order.to_s
      output << "Some items are not available at this moment: #{@invalid_items}\n" if @invalid_items.any?
      output
    end

    private

    def create_order_items
      product_list_to_hash.map do |product_name, quantity|
        inventory_product = @inventory.find { |product| product.name.downcase == product_name.downcase }

        if inventory_product
          pricing = inventory_product.pricing(quantity)

          @order.push_order_item(Entities::OrderItem.new(product: inventory_product,
                                                         quantity: quantity,
                                                         price: pricing[:total] - pricing[:discount],
                                                         discount: pricing[:discount]))
        else
          @invalid_items << product_name
        end
      end
    end

    def product_list_to_hash
      @product_list.each_with_object(Hash.new(0)) { |product, acc| acc[product] += 1 }
    end
  end
end
