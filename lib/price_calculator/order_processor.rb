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

    def call
      create_order_items
      # Thinking ahead, here we might have the order processing in a transactional way,
      # for now we only care of order_items building based on requirements
      # process_order
    end

    def total_to_pay
      calculate_total(:total_to_pay)
    end

    def total_discount
      calculate_total(:discount)
    end

    def to_s
      output = ''
      table = Text::Table.new
      table.head = %w[Item Quantity Price]

      @order_items.each do |order_item|
        table.rows << [order_item.product.name, order_item.quantity, "$#{order_item.total_to_pay.to_f}"]
      end

      output << table.to_s
      output << "Total price: $#{format_total(total_to_pay)}\n"
      output << "You saved: $#{format_total(total_discount)} today\n" unless total_discount.zero?
      output << "Some items are not available at this moment: #{@invalid_items}\n" if @invalid_items.any?
      output
    end

    private

    def create_order_items
      product_list_to_hash.map do |product_name, quantity|
        inventory_product = @inventory.find { |product| product.name.downcase == product_name.downcase }

        if inventory_product
          @order_items << Entities::OrderItem.new(inventory_product, quantity)
        else
          @invalid_items << product_name
        end
      end
    end

    def format_total(input)
      input.to_s('F')
    end

    def calculate_total(attribute)
      @order_items.map { |order_item| order_item.send(attribute) }.inject(BigDecimal(0), &:+).round(2)
    end

    def product_list_to_hash
      @product_list.each_with_object(Hash.new(0)) { |product, acc| acc[product] += 1 }
    end
  end
end
