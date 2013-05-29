class Country < ActiveRecord::Base
  attr_accessible :country_code, :name, :sound_file, :image_file
  has_many :regions

  GAFACHI_INDEX = {
  	
  }
end
