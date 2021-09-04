require 'spec_helper'

RSpec.describe PriceCalculator::Entities::Product do
  context 'without discount' do
    subject { described_class.new(name: 'Milk', unit_price: 1.5) }

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
                          unit_price: 1.5,
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
end
