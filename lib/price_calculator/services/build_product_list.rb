module PriceCalculator
  module Services
    class BuildProductList
      def initialize(input)
        @input = input
      end

      def call
        validate_input
        normalize_input
      end

      private

      def normalize_input
        @input.split(',').map(&:strip)
      end

      def validate_input
        raise Error, 'Product list is empty' if @input.nil? || @input.empty?
      end
    end
  end
end
