require 'json'
require 'bigdecimal'
require 'price_calculator/entities/product'
require 'price_calculator/entities/discount'

module PriceCalculator
  module Services
    class BuildInventory
      def initialize(inventory_file_path)
        @inventory_file_path = inventory_file_path
      end

      def call
        build_inventory
      end

      private

      def build_inventory
        products = []

        parsed_inventory.each do |item|
          products << Entities::Product.new(name: item['name'],
                                            unit_price: item['unit_price'],
                                            discount: build_discount(item))
        end

        products
      end

      def parsed_inventory
        file = File.read(@inventory_file_path)
        JSON.parse(file)
      rescue StandardError => e
        raise PriceCalculator::Error, 'Inventory parsing failed. Please try with another inventory file.'
      end

      def build_discount(item)
        return unless item['discount']

        quantity = item.dig('discount', 'quantity')
        discount_price = BigDecimal(item.dig('discount', 'price'), 8)
        unit_price = BigDecimal(item['unit_price'], 8)

        raise Error, 'Invalid Discount Found' if discount_price > (quantity * unit_price)

        Entities::Discount.new(quantity: quantity, price: discount_price)
      end
    end
  end
end
