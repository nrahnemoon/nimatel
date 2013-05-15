class AdminController < ApplicationController
	http_basic_authenticate_with :name=>"morteza", :password=>"r4hn3m00n"

  def index
  end

  def cards
  end

  def logs
  end
end
