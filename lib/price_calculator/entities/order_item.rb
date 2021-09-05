require 'price_calculator/entities/types'
require 'price_calculator/entities/product'

module PriceCalculator
  module Entities
    class OrderItem < ::Dry::Struct
      attribute :product, Product
      attribute :quantity, Types::Strict::Integer
      attribute :net_price, Types::Strict::Decimal
      attribute :discount, Types::Strict::Decimal
    end
  end
end
