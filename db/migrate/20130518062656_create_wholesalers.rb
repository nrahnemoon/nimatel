class CreateWholesalers < ActiveRecord::Migration
  def change
    create_table :wholesalers do |t|
      t.string :name
      t.string :ip
      t.string :username
      t.string :password
      t.string :auth_id
      t.string :auth_secret

      t.timestamps
    end
  end
end
