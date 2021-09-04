require 'thor'
require 'json'
require 'price_calculator/order_processor'
require 'price_calculator/services/build_inventory'
require 'price_calculator/services/build_product_list'

module PriceCalculator
  class CLI < Thor
    desc 'order PRODUCTS', 'This will return the price of products provided'
    long_desc <<-ORDER
    `order PRODUCTS` will calculate the price for a list of comma separated products.
    You can also pass the an `inventory_path` which consists of a JSON file with the
    products and discounts.
    ORDER

    option :inventory_file_path

    def order
      products = ask('Please enter all the items purchased separated by a comma:')
      inventory_file_path = ENV['INVENTORY_FILE_PATH'] || options[:inventory_file_path]

      return unless valid_file_path?(inventory_file_path)

      inventory = PriceCalculator::Services::BuildInventory.new(inventory_file_path).call
      product_list = PriceCalculator::Services::BuildProductList.new(products).call

      PriceCalculator::OrderProcessor.new(inventory: inventory, product_list: product_list).print_price_table
    rescue PriceCalculator::Error => e
      say "Error: #{e}"
    end

    private

    def valid_file_path?(inventory_file_path)
      # Validates presence
      if inventory_file_path.nil?
        say 'Error: You need to provide an INVENTORY file'
        return false
      end

      # Validates existence
      unless File.exist?(inventory_file_path)
        say 'Error: Invalid path'
        false
      end

      true
    end
  end
end
