module PriceCalculator
  module Utils
    def normalize_input(input)
      input.split(',').map(&:strip)
    end
  end
end
