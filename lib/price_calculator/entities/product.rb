require 'bigdecimal'
require 'price_calculator/entities/types'
require 'price_calculator/entities/discount'

module PriceCalculator
  module Entities
    class Product < ::Dry::Struct
      attribute :name, Types::Strict::String
      attribute :unit_price, Types::Coercible::Decimal
      attribute :discount, Discount | Types::Nil

      def pricing(ordered_quantity)
        total = ordered_quantity * unit_price
        total_discount = discounted_price(total, ordered_quantity)

        { total: total, discount: total_discount }
      end

      private

      def discounted_price(total, ordered_quantity)
        return BigDecimal(0) unless discount_applicable?(ordered_quantity)

        not_discounted = ordered_quantity % discount.quantity
        discounted = (ordered_quantity - not_discounted) / discount.quantity

        total - (discounted * discount.price + not_discounted * unit_price)
      end

      def discount_applicable?(ordered_quantity)
        discount &&  ordered_quantity >= discount.quantity
      end
    end
  end
end
