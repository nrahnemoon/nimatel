class User < ActiveRecord::Base
	attr_accessible :email, :password, :password_confirmation, :cim_profile_id, :default_payment_profile_id

	has_many :cards
	has_many :phone_numbers
	has_many :payment_profiles
	has_one :renewal_plan
	has_secure_password
	validates_presence_of :password, :on => :create
end
