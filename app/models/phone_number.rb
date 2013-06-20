class PhoneNumber < ActiveRecord::Base
  attr_accessible :number, :remember, :user_id, :caller_id_name

  belongs_to :user
  has_many :transactions
end
