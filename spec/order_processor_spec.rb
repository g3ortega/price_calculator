require 'spec_helper'

RSpec.describe PriceCalculator::OrderProcessor do
  describe '#print_price_table' do
    before do
      @old_stderr = $stderr
      $stderr = StringIO.new
      @old_stdout = $stdout
      $stdout = StringIO.new
    end

    after do
      $stderr = @old_stderr
      $stdout = @old_stdout
    end

    let(:inventory) { PriceCalculator::Services::LoadInventory.new('spec/data/valid_inventory_file.json').call }

    context 'with all products available in inventory' do
      let(:product_list) { PriceCalculator::Services::BuildProductList.new('milk,milk,bread,bread').call }
      subject { described_class.new(inventory: inventory, product_list: product_list) }

      it 'returns a print table' do
        subject.call

        expect(subject.to_s).to eq <<~PRICINGTABLE
          +-------+----------+-------+
          | Item  | Quantity | Price |
          +-------+----------+-------+
          | Milk  | 2        | $5.0  |
          | Bread | 2        | $4.34 |
          +-------+----------+-------+
          Total price: $9.34
          You saved: $2.94 today
        PRICINGTABLE
      end
    end

    context 'with some products not available in inventory' do
      let(:product_list) { PriceCalculator::Services::BuildProductList.new('milk,bread,bread,nope,etc').call }
      subject { described_class.new(inventory: inventory, product_list: product_list) }

      it 'returns a print table' do
        subject.call

        expect(subject.to_s).to eq <<~PRICINGTABLE
          +-------+----------+-------+
          | Item  | Quantity | Price |
          +-------+----------+-------+
          | Milk  | 1        | $3.97 |
          | Bread | 2        | $4.34 |
          +-------+----------+-------+
          Total price: $8.31
          Some items are not available at this moment: ["nope", "etc"]
        PRICINGTABLE
      end
    end
  end
end
