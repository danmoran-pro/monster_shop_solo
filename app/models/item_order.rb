class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order

  enum status: %w(fulfilled unfulfilled)

  def subtotal
    price * quantity
  end
end
