require 'thor'
require 'price_calculator/services/order_processor'
require 'price_calculator/services/load_inventory'
require 'price_calculator/services/input_processor'

module PriceCalculator
  class CLI < Thor
    desc 'order PRODUCTS', 'This will return the price of products provided'
    option :inventory_file_path

    def order
      inventory = Services::LoadInventory.new(inventory_file_path).call

      input = ask('Please enter all the items purchased separated by a comma:')

      purchased_items_list = Services::InputProcessor.new(input).call
      order_processor = Services::OrderProcessor.new(inventory: inventory,
                                                     product_list: purchased_items_list).perform

      puts order_processor.to_s
    rescue PriceCalculator::Error => e
      say "Error: #{e}"
    end

    desc 'pricing_table', 'Print pricing table from inventory_file'
    option :inventory_file_path

    def pricing_table
      puts Services::LoadInventory.new(inventory_file_path).to_s
    rescue PriceCalculator::Error => e
      say "Error: #{e}"
    end

    private

    def inventory_file_path
      ENV['INVENTORY_FILE_PATH'] || options[:inventory_file_path]
    end
  end
end
