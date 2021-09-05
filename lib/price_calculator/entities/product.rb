require 'price_calculator/entities/types'
require 'price_calculator/entities/discount'

module PriceCalculator
  module Entities
    class Product < ::Dry::Struct
      attribute :name, Types::Strict::String
      attribute :unit_price, Types::Coercible::Decimal
      attribute :discount, Discount | Types::Nil

      def calculate_total(quantity)
        total = quantity * unit_price

        total_discounted = if discount && quantity >= discount.quantity
                             not_discounted = quantity % discount.quantity
                             discounted = (quantity - not_discounted) / discount.quantity

                             total - (discounted * discount.price + not_discounted * unit_price)
                           else
                             0
                           end

        { total: quantity * unit_price, discount: total_discounted }
      end
    end
  end
end
