require 'benchmark'
require 'bigdecimal'
require 'dry-types'
require 'dry-struct'

REP = 1000000

DATA = { name: "Milk", unit_price: '9.99' }

class Product
  attr_accessor :name, :unit_price

  def initialize(name:, unit_price:)
    @name = name
    @unit_price = BigDecimal(unit_price, 8)
  end
end

module Types
  include Dry.Types()
end

class DryProduct < Dry::Struct
  attribute :name, Types::Strict::String
  attribute :unit_price, Types::Coercible::Decimal
end

Benchmark.bmbm do |x|
  x.report 'PORO create and access with keyword arguments' do
    REP.times do
      product = Product.new(DATA)
      "#{product.name} - #{product.unit_price}"
    end
  end

  x.report 'dry-type + dry-struct create and access' do
    REP.times do
      product = DryProduct.new(DATA)
      "#{product.name} - #{product.unit_price}"
    end
  end
end
