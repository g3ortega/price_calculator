require 'thor'
require 'json'
require 'price_calculator/utils'

module PriceCalculator
  class CLI < Thor
    include PriceCalculator::Utils

    desc 'order PRODUCTS', 'This will return the price of products provided'
    long_desc <<-ORDER
    `order PRODUCTS` will calculate the price for a list of comma separated products.
    You can also pass the an `inventory_path` which consists of a JSON file with the
    products and discounts.
    ORDER

    option :inventory_path

    def order(products)
      inventory_file_path = ENV['INVENTORY_PATH'] || options[:inventory_path]

      # Validates presence
      if inventory_file_path.nil?
        say 'You need to provide an INVENTORY file'
        return
      end

      # Validates existence
      unless File.exist?(inventory_file_path)
        say 'Invalid path'
        return
      end

      # Validates content
      file = File.read(inventory_file_path)
      parsed_data = JSON.parse(file)


      # Validates input
      product_names = normalize_input(products)

      # Build Product Order
      p product_names
    end
  end
end
