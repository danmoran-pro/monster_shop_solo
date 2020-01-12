class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :percentage_off
  validates :name, uniqueness: true, presence: true
  validates :code, uniqueness: true, presence: true

  belongs_to :merchant, optional: true

end
