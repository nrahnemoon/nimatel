class Card < ActiveRecord::Base
  attr_accessible :balance, :pin
  validates :pin, :presence => true, :uniqueness => true, :length => { :is => 12 }, :numericality => { :only_integer => true }
  validates :balance, :presence => true, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than_or_equal_to => 0}
end
