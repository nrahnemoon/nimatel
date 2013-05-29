class Region < ActiveRecord::Base
  attr_accessible :name, :region_code
  belongs_to :country
end
