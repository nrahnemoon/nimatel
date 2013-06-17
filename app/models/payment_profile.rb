class PaymentProfile < ActiveRecord::Base
  attr_accessible :brand, :exp_month, :exp_year, :id, :last_four, :user_id

  belongs_to :user
end
