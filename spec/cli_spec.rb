require 'spec_helper'

RSpec.describe PriceCalculator::CLI do
  before do
    @shell = PriceCalculator::CLI.new
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
      @shell.options = { inventory_file_path: './data/inventory.json' }
    end

    context 'right input' do
      it 'renders order pricing for all order items' do
        expect(Thor::LineEditor).to receive(:readline)
          .with('Please enter all the items purchased separated by a comma: ', {})
          .and_return('milk,milk, bread,banana,bread,bread,bread,milk,apple')

        @shell.order

        expect($stdout.string).to eq <<~ORDERPRICING
          +--------+----------+-------+
          |  Item  | Quantity | Price |
          +--------+----------+-------+
          | Milk   | 3        | $8.97 |
          | Bread  | 4        | $8.17 |
          | Banana | 1        | $0.99 |
          | Apple  | 1        | $0.89 |
          +--------+----------+-------+
          Total price: $19.02
          You saved: $3.45 today
        ORDERPRICING
      end

      it 'renders order pricing for with some invalid items' do
        expect(Thor::LineEditor).to receive(:readline)
          .with('Please enter all the items purchased separated by a comma: ', {})
          .and_return('milk,milk,nope,etc,bread,bread,bread,milk,apple')

        @shell.order

        expect($stdout.string).to eq <<~ORDERPRICING
          +-------+----------+-------+
          | Item  | Quantity | Price |
          +-------+----------+-------+
          | Milk  | 3        | $8.97 |
          | Bread | 3        | $6.0  |
          | Apple | 1        | $0.89 |
          +-------+----------+-------+
          Total price: $15.86
          You saved: $3.45 today
          Some items are not available at this moment: ["nope", "etc"]
        ORDERPRICING
      end
    end

    context 'wrong input' do
      it 'renders an error when an empty string is provided' do
        expect(Thor::LineEditor).to receive(:readline)
          .with('Please enter all the items purchased separated by a comma: ', {})
          .and_return('')

        @shell.order

        expect($stdout.string).to eq("Error: Product list is empty\n")
      end
    end
  end
end
