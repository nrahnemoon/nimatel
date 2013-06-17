class PhoneNumber < ActiveRecord::Base
  attr_accessible :number, :remember, :user_id

  belongs_to :user
end
