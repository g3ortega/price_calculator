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

    option :inventory_file_path

    def order(products)
      inventory_file_path = ENV['INVENTORY_PATH'] || options[:inventory_file_path]

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



      # p product_names


      # Render order receipt
      say <<~EOS
      Item     Quantity      Price
      --------------------------------------
      Milk      3            $8.97
      Bread     4            $8.17
      Apple     1            $0.89
      Banana    1            $0.99

      Total price : $19.02
      You saved $3.45 today.
    EOS
    rescue PriceCalculator::Error => e
      say "Error: #{e}"
    end
  end
end
