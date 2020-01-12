class CreateCoupon < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :percentage_off

      t.timestamps
      t.references :merchant, foreign_key: true
    end
  end
end
