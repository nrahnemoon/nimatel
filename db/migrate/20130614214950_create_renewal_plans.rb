class CreateRenewalPlans < ActiveRecord::Migration
  def change
    create_table :renewal_plans do |t|
      t.integer :user_id
      t.boolean :auto_renew
      t.decimal :increment

      t.timestamps
    end
  end
end
