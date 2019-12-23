class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :current_status

  has_many :item_orders
  has_many :items, through: :item_orders

  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def cancel
    item_orders.each do |item_order|
      item_order.update(status: 0)
      item_order.item.update(inventory: item_order.item.inventory + item_order.quantity)
    end
    update(current_status: "CANCELLED")
  end

  def fulfill
    item_orders.each do |item_order|
      item_order.update(status: 1)
    end
    update(current_status: "FULFILLED")
  end
end
