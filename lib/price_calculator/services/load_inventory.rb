require 'json'
require 'bigdecimal'
require 'text-table'
require 'price_calculator/entities/product'
require 'price_calculator/entities/discount'

module PriceCalculator
  module Services
    class LoadInventory
      def initialize(inventory_file_path)
        @inventory_file_path = inventory_file_path
      end

      def call
        validates_file_path
        build_inventory
      end

      def to_s
        validates_file_path
        inventory = build_inventory

        table = Text::Table.new
        table.head = ['Item', 'Unit Price', 'Sale Price']

        inventory.each do |product|
          discount_statement = product.discount ? "#{product.discount.quantity} for $#{product.discount.price.to_s('F')}" : ""
          table.rows << [product.name, "$#{product.unit_price.to_s('F')}", discount_statement]
        end

        table.to_s
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
      rescue StandardError
        raise PriceCalculator::Error, 'Inventory parsing failed. Please try with another inventory file.'
      end

      def build_discount(item)
        return unless item['discount']

        discount_quantity = item.dig('discount', 'quantity').to_i
        discount_price = item.dig('discount', 'price').to_d
        unit_price = (item['unit_price']).to_d

        raise Error, 'Invalid Discount Found' if discount_price > (discount_quantity * unit_price)

        Entities::Discount.new(quantity: discount_quantity, price: discount_price)
      end

      def validates_file_path
        # Validates presence
        raise Error, 'You need to provide an INVENTORY file' if @inventory_file_path.nil?

        # Validates existence
        raise Error, 'Invalid path' unless File.exist?(@inventory_file_path)
      end
    end
  end
end
