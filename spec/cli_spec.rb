require 'spec_helper'

RSpec.describe PriceCalculator::CLI do
  before do
    @cli = PriceCalculator::CLI.new
    @old_stderr = $stderr
    $stderr = StringIO.new
    @old_stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stderr = @old_stderr
    $stdout = @old_stdout
  end

  describe '#order' do
    before do
      @cli.options = { inventory_file_path: './data/inventory.json' }
    end

    context 'right input' do
      it 'renders order details' do
        @cli.order('milk,milk, bread,banana,bread,bread,bread,milk,apple')

        expect($stdout.string).to  eq <<~EOS
        Item     Quantity      Price
        --------------------------------------
        Milk      3            $8.97
        Bread     4            $8.17
        Apple     1            $0.89
        Banana    1            $0.99

        Total price : $19.02
        You saved $3.45 today.
      EOS
      end
    end

    context 'wrong input' do
      it 'renders an error' do
        @cli.order('')

        expect($stdout.string).to eq("Error: Product list is empty\n")
      end
    end
  end
end
