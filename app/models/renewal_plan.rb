class RenewalPlan < ActiveRecord::Base
  attr_accessible :auto_renew, :increment, :user_id, :min_balance
  belongs_to :user
end
