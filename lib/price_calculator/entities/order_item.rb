require 'price_calculator/entities/types'
require 'price_calculator/entities/product'

module PriceCalculator
  module Entities
    class OrderItem < ::Dry::Struct
      attribute :product, Product
      attribute :quantity, Types::Strict::Integer

      def price_details
        { total: product_price_detail[:total] - product_price_detail[:discount],
          discount: product_price_detail[:discount] }
      end

      private

      def product_price_detail
        @product_price_detail ||= product.calculate_total(quantity)
      end
    end
  end
end
