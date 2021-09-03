require 'spec_helper'

RSpec.describe PriceCalculator::Utils do
  before :all do
    class Base; end
  end

  before do
    @test = Base.new
    @test.extend(PriceCalculator::Utils)
  end

  describe '#normalize_input' do
    it 'returns a normalized array given a comma separated list string' do
      expect(@test.send(:normalize_input, 'bread,bread    , bread')).to eq(['bread', 'bread', 'bread'])
    end
  end
end
