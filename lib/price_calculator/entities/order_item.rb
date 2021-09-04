module PriceCalculator
  module Entities
    class OrderItem
      attr_reader :product, :quantity, :total_to_pay, :discount

      def initialize(product, quantity)
        @product = product
        @quantity = quantity
        calculate_price
      end

      private

      def calculate_price
        @total_to_pay = product_price_detail[:total] - product_price_detail[:discount]
        @discount = product_price_detail[:discount]
      end

      def product_price_detail
        @product_price_detail ||= product.calculate_total(quantity)
      end
    end
  end
end
