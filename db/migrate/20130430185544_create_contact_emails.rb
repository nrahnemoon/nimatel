class CreateContactEmails < ActiveRecord::Migration
  def change
    create_table :contact_emails do |t|
      t.string :name
      t.string :email
      t.integer :pin
      t.integer :purpose
      t.string :message

      t.timestamps
    end
  end
end
