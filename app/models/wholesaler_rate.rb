class WholesalerRate < ActiveRecord::Base
  attr_accessible :billing_increment, :country, :description, :min_charge, :rate, :wholesaler_id
  belongs_to :wholesaler
  has_many :wholesaler_prefixes
end
