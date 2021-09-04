require 'spec_helper'

RSpec.describe PriceCalculator::Services::BuildInventory do
  describe '#call' do
    context 'valid JSON file' do
      subject { described_class.new('spec/data/valid_inventory_file.json') }

      it 'returns a list of products' do
        response = subject.call

        expect(response).to be_a(Array)
        expect(response.count).to be(4)
        expect(response.map(&:name)).to include('Milk', 'Bread', 'Banana', 'Apple')
      end
    end

    context 'empty JSON file' do
      subject { described_class.new('spec/data/empty_inventory_file.json') }

      it 'returns a list of products' do
        expect do
          subject.call
        end.to raise_error(PriceCalculator::Error, /Inventory parsing failed. Please try with another inventory file./)
      end
    end

    context 'JSON file with invalid discount' do
      subject { described_class.new('spec/data/inventory_with_invalid_discount.json') }

      it 'returns a list of products' do
        expect do
          subject.call
        end.to raise_error(PriceCalculator::Error, /Invalid Discount Found/)
      end
    end
  end
end
