require 'text-table'
require 'price_calculator/entities/order_item'

module PriceCalculator
  class OrderProcessor
    def initialize(inventory:, product_list:, state: 'started')
      @inventory = inventory
      @product_list = product_list
      @state = state
      @order_items = []
      @invalid_items = []
    end

    def print_price_table
      create_order_items

      table = Text::Table.new
      table.head = ['Item', 'Quantity', 'Price']

      @order_items.each do |order_item|
        table.rows << [order_item.product.name, order_item.quantity, "$#{order_item.total_to_pay}"]
      end

      puts table.to_s
      puts "Total price: $#{@order_items.map(&:total_to_pay).inject(0, &:+).round(2)}"
      puts "You saved: $#{@order_items.map(&:discount).inject(0, &:+).round(2)} today"
      puts "Some items are not available at this moment: #{@invalid_items}" if @invalid_items.any?
    end

    private

    def create_order_items
      product_list_to_hash.map do |product_name, quantity|
        inventory_product = @inventory.find { |product| product.name.downcase == product_name.downcase }

        if inventory_product
          @order_items << OrderItem.new(inventory_product, quantity)
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
