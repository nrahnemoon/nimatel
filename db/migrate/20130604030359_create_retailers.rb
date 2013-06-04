class CreateRetailers < ActiveRecord::Migration
  def change
    create_table :retailers do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :gender
      t.string :phone_number
      t.string :fax_number
      t.string :contact
      t.string :contact_title
      t.string :website
      t.integer :num_employees
      t.string :sales
      t.string :industry
      t.string :sic
      t.string :sic_description
      t.string :email
      t.boolean :has_calling_card

      t.timestamps
    end
  end
end
