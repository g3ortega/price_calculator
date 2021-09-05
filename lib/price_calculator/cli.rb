require 'thor'
require 'json'
require 'price_calculator/order_processor'
require 'price_calculator/services/load_inventory'
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
      inventory_file_path = ENV['INVENTORY_FILE_PATH'] || options[:inventory_file_path]
      inventory = Services::LoadInventory.new(inventory_file_path).call

      products = ask('Please enter all the items purchased separated by a comma:')

      product_list = Services::BuildProductList.new(products).call
      order_processor = OrderProcessor.new(inventory: inventory, product_list: product_list).perform

      puts order_processor.to_s
    rescue PriceCalculator::Error => e
      say "Error: #{e}"
    end

    desc 'pricing_table', 'Print pricing table from inventory_file'
    option :inventory_file_path

    def pricing_table
      inventory_file_path = ENV['INVENTORY_FILE_PATH'] || options[:inventory_file_path]
      puts Services::LoadInventory.new(inventory_file_path).to_s
    rescue PriceCalculator::Error => e
      say "Error: #{e}"
    end
  end
end
