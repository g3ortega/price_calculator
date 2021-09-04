class Product
  attr_reader :name, :unit_price, :discount

  def initialize(name:, unit_price:, discount: nil)
    @name = name
    @unit_price = unit_price
    @discount = discount
  end

  def calculate_total(quantity)
    total = quantity * unit_price

    discount = if @discount && quantity >= @discount.quantity
                 not_discounted = quantity % @discount.quantity
                 discounted = (quantity - not_discounted) / @discount.quantity

                 total - (discounted * @discount.price + not_discounted * @unit_price)
               else
                 0
               end

    { total: quantity * unit_price, discount: discount }
  end
end
