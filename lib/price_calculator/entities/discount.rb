require 'bigdecimal'

module PriceCalculator
  module Entities
    class Discount
      attr_reader :quantity, :price

      def initialize(quantity:, price:)
        @quantity = quantity
        @price = BigDecimal(price, 8)
      end
    end
  end
end
