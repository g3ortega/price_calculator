require 'spec_helper'

RSpec.describe PriceCalculator::Entities::OrderItem do
  describe 'initialization with discounted product' do
    before do
      discount = PriceCalculator::Entities::Discount.new(quantity: 2, price: '3.0')
      @product = PriceCalculator::Entities::Product.new(name: 'Milk', unit_price: '1.99', discount: discount)
    end

    it 'initialize OrderItem including price details for product' do
      order_item = described_class.new(@product, 5)
      expect(order_item.product).to eq(@product)
      expect(order_item.quantity).to eq(5)
      expect(order_item.total_to_pay.to_f).to eq(7.99)
    end
  end

  describe 'initialization without discounted product' do
    before do
      @product = PriceCalculator::Entities::Product.new(name: 'Milk', unit_price: '1.99')
    end

    it 'initialize OrderItem including price details for product' do
      order_item = described_class.new(@product, 5)
      expect(order_item.product).to eq(@product)
      expect(order_item.quantity).to eq(5)
      expect(order_item.total_to_pay.to_f).to eq(9.95)
    end
  end
end
