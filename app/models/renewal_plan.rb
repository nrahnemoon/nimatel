class RenewalPlan < ActiveRecord::Base
  attr_accessible :auto_renew, :increment, :user_id
end
