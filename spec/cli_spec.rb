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
      @shell.options = { inventory_file_path: 'spec/data/valid_inventory_file.json' }
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

      it 'renders order pricing without discounted items' do
        expect(Thor::LineEditor).to receive(:readline)
          .with('Please enter all the items purchased separated by a comma: ', {})
          .and_return('bread,bread,milk,apple')

        @shell.order

        expect($stdout.string).to eq <<~ORDERPRICING
          +-------+----------+-------+
          | Item  | Quantity | Price |
          +-------+----------+-------+
          | Bread | 2        | $4.34 |
          | Milk  | 1        | $3.97 |
          | Apple | 1        | $0.89 |
          +-------+----------+-------+
          Total price: $9.2
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

  describe '#pricing_table' do
    context 'right input' do
      before do
        @shell.options = { inventory_file_path: 'spec/data/valid_inventory_file.json' }
      end

      it 'renders order pricing for all order items' do
        @shell.pricing_table

        expect($stdout.string).to eq <<~PRICINGTABLE
        +--------+------------+------------+
        |  Item  | Unit Price | Sale Price |
        +--------+------------+------------+
        | Milk   | $3.97      | 2 for $5.0 |
        | Bread  | $2.17      | 3 for $6.0 |
        | Banana | $0.99      |            |
        | Apple  | $0.89      |            |
        +--------+------------+------------+
        PRICINGTABLE
      end
    end

    context 'wrong/empty inventory_file_path' do
      it 'print an error when no inventory_file_path is provided' do
        @shell.pricing_table

        expect($stdout.string).to eq("Error: You need to provide an INVENTORY file\n")
      end

      it 'print an error when no inventory_file_path does not exist' do
        @shell.options = { inventory_file_path: 'spec/data/random_unexistent_path_to_file.json' }
        @shell.pricing_table

        expect($stdout.string).to eq("Error: Invalid path\n")
      end

      it 'print an error when file provided is empty or invalid' do
        @shell.options = { inventory_file_path: 'spec/data/empty_inventory_file.json' }
        @shell.pricing_table

        expect($stdout.string).to eq("Error: Inventory parsing failed. Please try with another inventory file.\n")
      end
    end
  end
end
