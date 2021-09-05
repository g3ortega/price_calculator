require 'spec_helper'

RSpec.describe PriceCalculator::Entities::Order do
  let(:inventory) { PriceCalculator::Services::LoadInventory.new('spec/data/valid_inventory_file.json').call }

  describe '#push_order_item' do
    subject { described_class.new }

    context 'adding duplicated products' do
      it 'raise an error when duplicated product is added' do
        order_item = PriceCalculator::Entities::OrderItem.new(product: inventory.first, quantity: 5,
                                                              net_price: BigDecimal(10), discount: BigDecimal(0))

        order_item_with_same_product = PriceCalculator::Entities::OrderItem.new(product: inventory.first,
                                                                                quantity: 3,
                                                                                net_price: BigDecimal(10),
                                                                                discount: BigDecimal(0))

        subject.push_order_item(order_item)
        expect(subject.order_items).to include(order_item)

        expect do
          subject.push_order_item(order_item_with_same_product)
        end.to raise_error(PriceCalculator::Error, /Duplicated Product Added/)
      end
    end

    context 'adding other type than order_item' do
      it 'raise an error when type mismatch is detected' do
        expect do
          subject.push_order_item(Hash.new(0))
        end.to raise_error(PriceCalculator::Error, /Type Mismatch Detected/)
      end
    end

    context 'adding valid order items' do
      it 'adds valid order items and calculates the right totals' do
        subject.push_order_item PriceCalculator::Entities::OrderItem.new(product: inventory[0], quantity: 5,
                                                                         net_price: BigDecimal(10), discount: BigDecimal(0))

        subject.push_order_item PriceCalculator::Entities::OrderItem.new(product: inventory[1], quantity: 5,
                                                                         net_price: BigDecimal(5), discount: BigDecimal(3))

        expect(subject.order_items.count).to eq(2)
        expect(subject.total_to_pay).to eq(15.0)
        expect(subject.total_discounted).to eq(3.0)

        subject.push_order_item PriceCalculator::Entities::OrderItem.new(product: inventory[2], quantity: 5,
                                                                         net_price: BigDecimal(10), discount: BigDecimal(5))

        expect(subject.order_items.count).to eq(3)
        expect(subject.total_to_pay).to eq(25.0)
        expect(subject.total_discounted).to eq(8.0)
      end
    end
  end
end
