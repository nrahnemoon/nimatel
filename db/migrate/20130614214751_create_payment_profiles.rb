class CreatePaymentProfiles < ActiveRecord::Migration
  def change
    create_table :payment_profiles do |t|
      t.integer :id
      t.integer :brand
      t.string :last_four
      t.integer :exp_month
      t.integer :exp_year
      t.integer :user_id

      t.timestamps
    end
  end
end
