class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :pin
      t.float :balance

      t.timestamps
    end
  end
end
