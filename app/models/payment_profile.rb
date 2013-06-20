class PaymentProfile < ActiveRecord::Base
  attr_accessible :brand, :exp_month, :exp_year, :id, :last_four, :user_id, :card_code, :bin, :cim_payment_profile_id

  belongs_to :user
  has_many :transactions
end
