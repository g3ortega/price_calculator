require 'spec_helper'

RSpec.describe PriceCalculator::Services::BuildProductList do
  context 'with valid input' do
    subject { described_class.new('milk,milk') }

    it 'return product list' do
      response = subject.call

      expect(response).to eq(%w[milk milk])
    end
  end

  context 'with empty input' do
    subject { described_class.new('') }

    it 'return product list' do
      expect do
        subject.call
      end.to raise_error(PriceCalculator::Error, /Product list is empty/)
    end
  end
end
