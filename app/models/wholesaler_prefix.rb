class WholesalerPrefix < ActiveRecord::Base
  attr_accessible :prefix, :wholesaler_rate_id
  belongs_to :wholesaler_rate
end
