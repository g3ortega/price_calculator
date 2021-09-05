require 'spec_helper'

RSpec.describe PriceCalculator::Entities::OrderItem do
  describe 'initialization with discounted product' do
    before do
      discount = PriceCalculator::Entities::Discount.new(quantity: 2, price: '3.0')
      @product = PriceCalculator::Entities::Product.new(name: 'Milk', unit_price: '1.99', discount: discount)
    end

    it 'initialize OrderItem including price details for product' do
      order_item = described_class.new(product: @product, quantity: 5, net_price: BigDecimal('3.99'),
                                       discount: BigDecimal('0'))
      expect(order_item.product).to eq(@product)
      expect(order_item.quantity).to eq(5)
      expect(order_item.net_price).to eq(3.99)
    end
  end

  describe 'initialization without discounted product' do
    before do
      @product = PriceCalculator::Entities::Product.new(name: 'Milk', unit_price: '1.99', discount: nil)
    end

    it 'initialize OrderItem including price details for product' do
      order_item = described_class.new(product: @product, quantity: 5, net_price: BigDecimal('3.99'),
                                       discount: BigDecimal('0'))
      expect(order_item.product).to eq(@product)
      expect(order_item.quantity).to eq(5)
      expect(order_item.net_price).to eq(3.99)
    end
  end

  describe 'type validation' do
    before do
      @product = PriceCalculator::Entities::Product.new(name: 'Milk', unit_price: '1.99', discount: nil)
    end

    describe 'quantity' do
      it 'raise exception when wrong type is provided' do
        expect do
          described_class.new(quantity: 'nope', product: @product)
        end.to raise_error(Dry::Struct::Error, /has invalid type for :quantity/)
      end

      it 'allows building discount' do
        order_item = described_class.new(quantity: 5, product: @product, net_price: BigDecimal('2.99'),
                                         discount: BigDecimal(0))
        expect(order_item.quantity).to eq(5)
      end
    end

    describe 'product' do
      it 'raise exception when wrong type is provided' do
        expect do
          described_class.new(quantity: 1, product: 'nope')
        end.to raise_error(Dry::Struct::Error)
      end

      it 'allows building order_item' do
        order_item = described_class.new(quantity: 5, product: @product, net_price: BigDecimal('2.99'),
                                         discount: BigDecimal('1.99'))
        expect(order_item.product).to eq(@product)
      end
    end
  end
end
