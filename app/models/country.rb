class Country < ActiveRecord::Base
  attr_accessible :name, :sound_file, :image_file, :alpha2, :alpha3
  has_many :regions

  GAFACHI_INDEX = {
  	
  }
end
