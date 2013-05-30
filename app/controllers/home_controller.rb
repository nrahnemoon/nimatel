class HomeController < ApplicationController

	def index
	end

	def rates
	end

	def about
	end

	def contact_get
		@contact_email = ContactEmail.new

    respond_to do |format|
      format.html { render "contact.html.erb" }
      format.json { render json: @contact_email }
    end
	end

	def contact_post
		@contact_email = ContactEmail.new(params[:contact_email])
    flash.delete(:success)
    
    respond_to do |format|
      if @contact_email.save
        flash[:success] = "Your message was successfully sent.  We will respond shorltly."
        format.html { render "contact.html.erb" }
        format.json { render json: @contact_email, :status => :created, location: @contact_email }
      else
        format.html { render "contact.html.erb" }
        format.json { render json: @contact_email.errors, :status => :unprocessable_entity }
      end
    end
	end

end
