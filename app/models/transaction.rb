class Transaction < ActiveRecord::Base
  attr_accessible :amount, :cim_profile_id, :completed, :item_id, :payment_profile_id, :user_id, :voided, :phone_number_id
  belongs_to :user
  belongs_to :payment_profile
  belongs_to :phone_number

  ITEM = {
  	:test_card => 10,
  	:one_dollar_sample_card => 20,
    :five_dollar_card => 30,
    :ten_dollar_card => 40,
    :twenty_dollar_card => 50
  }

  ITEM_AMOUNT = {
  	:test_card => 2.00,
  	:one_dollar_sample_card => 1.00,
  	:five_dollar_card => 5.00,
  	:ten_dollar_card => 10.00,
  	:twenty_dollar_card => 20.00
  }

end
