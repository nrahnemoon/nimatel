class Country < ActiveRecord::Base
  attr_accessible :name, :sound_file, :image_file, :alpha2, :alpha3, :landline_rate, :mobile_rate, :satellite_rate
  has_many :regions
  has_many :wholesaler_rates

end
