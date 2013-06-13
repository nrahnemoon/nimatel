class WholesalerRate < ActiveRecord::Base
  attr_accessible :billing_increment, :country, :description, :min_charge, :rate, :wholesaler_id, :category, :country_id, :version
  belongs_to :wholesaler
  belongs_to :country
end
