require 'price_calculator/entities/types'

module PriceCalculator
  module Entities
    class Discount < ::Dry::Struct
      attribute :quantity, Types::Strict::Integer
      attribute :price, Types::Coercible::Decimal
    end
  end
end

