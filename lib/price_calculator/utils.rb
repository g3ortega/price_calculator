module PriceCalculator
  module Utils
    def normalize_input(input)
      raise Error.new('Product list is empty') if input.empty?

      input.split(',').map(&:strip)
    end
  end
end
