require 'json'
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
          if item['discount']
            discount = Discount.new(quantity: item.dig('discount', 'quantity'), price: item.dig('discount', 'price'))
          end

          products << Product.new(name: item['name'], unit_price: item['unit_price'], discount: discount)
        end

        products
      end

      def parsed_inventory
        file = File.read(@inventory_file_path)
        JSON.parse(file)
      rescue => e
        raise PriceCalculator::Error.new("Inventory parsing failed. Please try with another inventory file. Details: #{e}")
      end

      def validates_data
        # TODO: Validates that total from discount is not higher than unit price * quantity
      end
    end
  end
end
