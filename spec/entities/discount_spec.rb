require 'spec_helper'

RSpec.describe PriceCalculator::Entities::Discount do
  before do
    @discount = PriceCalculator::Entities::Discount.new(quantity: 2, price: 1.99)
  end

  describe 'attributes' do
    it 'responds to attributes' do
      expect(@discount.respond_to?(:quantity)).to be_truthy
      expect(@discount.respond_to?(:price)).to be_truthy
    end
  end
end
