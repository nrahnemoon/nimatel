class ContactEmail < ActiveRecord::Base
	validates_presence_of :email, :message, :name, :purpose
  attr_accessible :email, :message, :name, :pin, :purpose

  PURPOSE = {
    :general_feedback => 100,
    :customer_support => 200,
    :partnership_inquiry => 300,
    :investment_inquiry => 400,
    :other => 500
  }

end
