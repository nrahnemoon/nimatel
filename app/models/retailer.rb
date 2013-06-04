class Retailer < ActiveRecord::Base
  attr_accessible :address, :city, :contact, :contact_title, :country, :email, :fax_number, :gender, :has_calling_card, :industry, :name, :num_employees, :phone_number, :sales, :sic, :sic_description, :state, :website, :zip
end
