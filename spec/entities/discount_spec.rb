require 'spec_helper'

RSpec.describe PriceCalculator::Entities::Discount do
  describe 'attributes' do
    it 'responds to attributes' do
      discount = described_class.new(quantity: 2, price: '1.99')

      expect(discount.respond_to?(:quantity)).to be_truthy
      expect(discount.respond_to?(:price)).to be_truthy
    end

    context 'type validations' do
      describe 'quantity' do
        it 'raise exception when wrong type is provided' do
          expect do
            described_class.new(quantity: 'nope', price: '1.99')
          end.to raise_error(Dry::Struct::Error, /has invalid type for :quantity/)
        end

        it 'allows building discount' do
          discount = described_class.new(quantity: 5, price: '1.99')
          expect(discount.quantity).to eq(5)
        end
      end

      describe 'price' do
        it 'raise exception when wrong type is provided' do
          expect do
            described_class.new(quantity: 1, price: 'nope')
          end.to raise_error(Dry::Struct::Error, /has invalid type for :price/)
        end

        it 'allows building discount' do
          discount = described_class.new(quantity: 5, price: '1.99')
          expect(discount.price).to eq(BigDecimal('1.99'))
        end
      end
    end
  end
end
