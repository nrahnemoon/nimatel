class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.decimal :amount
      t.integer :item_id
      t.integer :cim_profile_id
      t.integer :payment_profile_id
      t.boolean :completed
      t.boolean :voided

      t.timestamps
    end
  end
end
