class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :device_id
      t.integer :product_id
      t.string :address
      t.string :consumer_name
      t.integer :payment
      t.decimal :total
      t.integer :amount

      t.timestamps
    end
  end
end
