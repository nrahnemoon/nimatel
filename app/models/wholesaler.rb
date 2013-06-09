require "uri"
require "net/http"
require "csv"

class Wholesaler < ActiveRecord::Base
  attr_accessible :auth_id, :auth_secret, :ip, :name, :password, :username
  has_many :wholesaler_rates
end
