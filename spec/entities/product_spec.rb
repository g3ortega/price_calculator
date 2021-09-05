require 'spec_helper'

RSpec.describe PriceCalculator::Entities::Product do
  context 'without discount' do
    subject { described_class.new(name: 'Milk', unit_price: '1.5', discount: nil) }

    it 'initializes a product with right attributes' do
      expect(subject.name).to eq('Milk')
      expect(subject.unit_price.to_f).to eq(1.5)
      expect(subject.discount).to be_nil
    end

    describe '#calculate_total' do
      it 'returns the right total' do
        total_detail = subject.calculate_total(5)

        expect(total_detail).to eq({ total: 7.5, discount: 0 })
      end
    end
  end

  context 'with discount' do
    let(:discount) { PriceCalculator::Entities::Discount.new(quantity: 2, price: '1.0') }

    subject do
      described_class.new(name: 'Milk',
                          unit_price: BigDecimal(1.5, 8),
                          discount: discount)
    end

    it 'initializes a product with right attributes' do
      expect(subject.name).to eq('Milk')
      expect(subject.unit_price.to_f).to eq(1.5)
      expect(subject.discount).to eq(discount)
    end

    describe '#calculate_total' do
      it 'returns the right total' do
        total_detail = subject.calculate_total(5)

        expect(total_detail).to eq({ total: 7.5, discount: 4.0 })
      end
    end
  end

  describe 'type checking' do
    describe 'name' do
      it 'raise exception when wrong type is provided' do
        expect do
          described_class.new(name: 12, unit_price: '2.5', discount: nil)
        end.to raise_error(Dry::Struct::Error)
      end

      it 'allows building discount' do
        product = described_class.new(name: 'Bread', unit_price: '2.5', discount: nil)
        expect(product.name).to eq('Bread')
      end
    end

    describe 'unit_price' do
      it 'raise exception when wrong type is provided' do
        expect do
          described_class.new(name: 'Milk', unit_price: { foo: 'bar' }, discount: nil)
        end.to raise_error(Dry::Struct::Error)
      end

      it 'allows building order_item' do
        product = described_class.new(name: 'Milk', unit_price: '1.99', discount: nil)
        expect(product.unit_price).to eq(BigDecimal('1.99'))
      end
    end

    describe 'discount' do
      it 'raise exception when wrong type is provided' do
        expect do
          described_class.new(name: 'Milk', unit_price: '1.99', discount: 'nope')
        end.to raise_error(Dry::Struct::Error)
      end

      it 'allows building order_item with no discount' do
        product = described_class.new(name: 'Milk', unit_price: '1.99', discount: nil)
        expect(product.discount).to be_nil
      end

      it 'allows building order_item with discount' do
        discount = PriceCalculator::Entities::Discount.new(quantity: 2, price: '1.99')
        product = described_class.new(name: 'Bread', unit_price: '1.99', discount: discount)
        expect(product.discount).to eq(discount)
      end
    end
  end
end
