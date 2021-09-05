module PriceCalculator
  module Entities
    class Order
      attr_reader :order_items, :state, :started_at

      def initialize
        @order_items = []
        @state = 'started'
        @started_at = Time.now
      end

      def push_order_item(item)
        raise Error, 'Type Mismatch Detected' unless item.is_a?(OrderItem)
        raise Error, 'Duplicated Product Added' if order_items.detect do |order_item|
                                                     order_item.product == item.product
                                                   end

        @order_items.push(item)
        clear_cache
      end

      def total_to_pay
        @total_to_pay ||= sum_collection_by(:price)
      end

      def total_discounted
        @total_discounted ||= sum_collection_by(:discount)
      end

      def to_s
        output = ''
        table = Text::Table.new
        table.head = %w[Item Quantity Price]

        order_items.each do |order_item|
          table.rows << [order_item.product.name, order_item.quantity, "$#{format_decimal(order_item.price)}"]
        end

        output << table.to_s
        output << "Total price: $#{format_decimal(total_to_pay)}\n"
        output << "You saved: $#{format_decimal(total_discounted)} today\n" unless total_discounted.zero?
        output
      end

      private

      def sum_collection_by(attribute)
        @order_items.collect.collect(&attribute).inject(BigDecimal(0, 8), &:+).round(2)
      end

      def clear_cache
        send(:remove_instance_variable, :@total_to_pay) if defined?(@total_to_pay)
        send(:remove_instance_variable, :@total_discounted) if defined?(@total_discounted)
      end

      def format_decimal(decimal)
        decimal.to_s('F')
      end
    end
  end
end
