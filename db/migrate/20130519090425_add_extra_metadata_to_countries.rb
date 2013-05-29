class AddExtraMetadataToCountries < ActiveRecord::Migration
  def up
  	add_column :countries, :sound_file, :string
  	add_column :countries, :image_file, :string
  end

  def down
  	remove_column :countries, :sound_file
  	remove_column :countries, :image_file
  end
end
