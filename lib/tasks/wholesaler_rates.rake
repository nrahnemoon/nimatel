require "uri"
require "net/http"
require "csv"

# Run the following command in production after deploying
# TODO: add this to cap deploy
# /usr/bin/env bundle exec rake region RAILS_ENV=production
desc "Import wholesaler rates from the web"
namespace :rates do
	task :gafachi => [:environment, :wholesalers] do
		ratesCsv = nil
		wholesaler = Wholesaler.find_by_name("Gafachi")
		version = nil
		if Rails.env == "production"
			version = WholesalerRate.where({ :wholesaler_id => wholesaler.id}).count == 0 ? nil : WholesalerRate.find_by_sql(
				"SELECT version FROM wholesaler_rates WHERE wholesaler_id = " + wholesaler.id.to_s +
				" ORDER BY version DESC LIMIT 1").first.version
			version = version == nil ? 0 : version + 1
			resp = Net::HTTP.get(URI('http://cmi.gafachi.com'))
		  	sessionIdKey = "'SessionID', '"
		  	sessionIdStartPos = resp.index(sessionIdKey) + sessionIdKey.length
		  	sessionIdEndPos = resp.index("',", sessionIdStartPos)
		  	sessionId = resp[sessionIdStartPos, sessionIdEndPos - sessionIdStartPos]
		  	loginUrlKey = "<FORM ACTION=\""
		  	loginUrlStartPos = resp.index(loginUrlKey) + loginUrlKey.length
		  	loginUrlEndPos = resp.index("\" METHOD=POST>")
		  	loginUrl = URI.parse(resp[loginUrlStartPos, loginUrlEndPos - loginUrlStartPos])
		  	loginHttp = Net::HTTP.new(loginUrl.host, loginUrl.port)
		  	loginHttp.use_ssl = (loginUrl.scheme == 'https')
		  	loginRequest = Net::HTTP::Post.new(loginUrl.request_uri)
		  	loginRequest.set_form_data({"POST" => "1", "LOGIN_USERNAME" => "nimatel", "LOGIN_PASSWORD" => "g4f4ch1"})
		  	loginResponse = loginHttp.start{|http| http.request(loginRequest) }
		  	ratesUrlBase = loginUrl.host + loginUrl.request_uri[0, loginUrl.request_uri.index("/0/1/proc/login/main/fp_")]
		  	ratesResp = Net::HTTP.get(URI("http://" + ratesUrlBase + "/3/0/prod/cmi/rates/volume_0/gafachirates_fmt1.csv"))
		  	ratesCsv = CSV.parse(ratesResp, :headers => true)
		 else
		 	ratesCsv = CSV.read("db/wholesaler_rates/gafachi.dev.csv", :headers => true)
		 end

      	ratesCsv.each do |row|
      		params = row.to_hash
        	if !params["Prefixes"]
        		region = Region.find_by_sql("SELECT * FROM regions WHERE '" +
	        		params["CountryCode"] + "' LIKE prefix || '%' ORDER BY prefix DESC LIMIT 1;").first
        		if Rails.env == "production"
        			WholesalerRate.create!({
        				:description => params["Country"].encode('utf-8', 'iso-8859-1') + " " + params["Description"].encode('utf-8', 'iso-8859-1'),
	            		:rate => Rails.env == "production" ? params["Rate per minute"][1..-1] : params["Rate per minute"],
	            		:billing_increment => params["Billing increment (in seconds)"],
	            		:min_charge => params["Minimum charge period (in seconds)"],
	            		:category => region.category,
	            		:country_id => region.country_id,
	            		:version => version,
	            		:prefix => params["CountryCode"],
	            		:wholesaler_id => wholesaler.id
        			})
        		else
	    			rate = WholesalerRate.find_or_initialize_by_prefix_and_wholesaler_id(params["CountryCode"], wholesaler.id)
	          		rate.update_attributes!({
	            		:description => params["Country"].encode('utf-8', 'iso-8859-1') + " " + params["Description"].encode('utf-8', 'iso-8859-1'),
	            		:rate => Rails.env == "production" ? params["Rate per minute"][1..-1] : params["Rate per minute"],
	            		:billing_increment => params["Billing increment (in seconds)"],
	            		:min_charge => params["Minimum charge period (in seconds)"],
	            		:category => region.category,
	            		:country_id => region.country_id
	          		})
        		end
        	else
         		prefixes = params["Prefixes"].split("&")
          		prefixes.each do |prefix|
          			region = Region.find_by_sql("SELECT * FROM regions WHERE '" +
	        			params["CountryCode"] + prefix + "' LIKE prefix || '%' ORDER BY prefix DESC LIMIT 1;").first
            		if Rails.env == "production"
            			WholesalerRate.create!({
	        				:description => params["Country"].encode('utf-8', 'iso-8859-1') + " " + params["Description"].encode('utf-8', 'iso-8859-1'),
		            		:rate => Rails.env == "production" ? params["Rate per minute"][1..-1] : params["Rate per minute"],
		            		:billing_increment => params["Billing increment (in seconds)"],
		            		:min_charge => params["Minimum charge period (in seconds)"],
		            		:category => region.category,
		            		:country_id => region.country_id,
		            		:version => version,
		            		:prefix => params["CountryCode"] + prefix,
		            		:wholesaler_id => wholesaler.id
	        			})
            		else
	            		rate = WholesalerRate.find_or_initialize_by_prefix_and_wholesaler_id(params["CountryCode"] + prefix, wholesaler.id)
	            		rate.update_attributes!({
	              			:description => params["Country"].encode('utf-8', 'iso-8859-1') + " " + params["Description"].encode('utf-8', 'iso-8859-1'),
	              			:rate => Rails.env == "production" ? params["Rate per minute"][1..-1] : params["Rate per minute"],
	              			:billing_increment => params["Billing increment (in seconds)"],
	              			:min_charge => params["Minimum charge period (in seconds)"],
	              			:category => region.category,
	              			:country_id => region.country_id
	            		})
	            	end
          		end
        	end
      	end
	end

	task :idt => [:environment] do
		ratesCsv = nil
		wholesaler = Wholesaler.find_by_name("IDT")
		version = nil
		if Rails.env == "production"
			version = WholesalerRate.where({ :wholesaler_id => wholesaler.id}).count == 0 ? nil : WholesalerRate.find_by_sql(
				"SELECT version FROM wholesaler_rates WHERE wholesaler_id = " + wholesaler.id.to_s +
				" ORDER BY version DESC LIMIT 1").first.version
			version = version == nil ? 0 : version + 1
			baseUrl = "https://secure.idtexpress.com"
		    url = URI(baseUrl + "/")
		    http = Net::HTTP.new(url.host, url.port)
		    http.use_ssl = true
		    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		    req = Net::HTTP::Get.new(url.request_uri)
		    resp = http.request(req)
		    cookies = resp.response["set-cookie"]
		    resp = resp.body
		    authenticityTokenKey = "\"authenticity_token\" type=\"hidden\" value=\""
		    authenticityTokenStartPos = resp.index(authenticityTokenKey) + authenticityTokenKey.length
		    authenticityTokenEndPos = resp.index("\" />", authenticityTokenStartPos)
		    authenticityToken = resp[authenticityTokenStartPos, authenticityTokenEndPos - authenticityTokenStartPos]
		    loginUrlKey = "accept-charset=\"UTF-8\" action=\""
		    loginUrlStartPos = resp.index(loginUrlKey) + loginUrlKey.length
		    loginUrlEndPos = resp.index("\" method=\"post\">", loginUrlStartPos)
		    loginUri = resp[loginUrlStartPos, loginUrlEndPos - loginUrlStartPos]
		    req = Net::HTTP::Post.new(loginUri, {"Cookie" => cookies})
		    req.set_form_data({"utf8" => "✓", "authenticity_token" => authenticityToken, "user[login]" => "nimatel1", "user[password]" => "1DT3xpr3ss", "commit" => "Sign in"})
		    resp = http.request(req)
		    cookies = resp.response["set-cookie"]
		    securityUri = "/security_challenge/"
		    req = Net::HTTP::Get.new(securityUri, {"Cookie" => cookies})
		    resp = http.request(req)
		    resp = resp.body
		    securityQuestionIdKey = "name=\"question_id\" type=\"hidden\" value=\""
		    securityQuestionIdStartPos = resp.index(securityQuestionIdKey) + securityQuestionIdKey.length
		    securityQuestionIdEndPos = resp.index("\"", securityQuestionIdStartPos)
		    question_id = resp[securityQuestionIdStartPos, securityQuestionIdEndPos - securityQuestionIdStartPos]
		    answer = ""
		    if question_id == "10000"
		      answer = "kobe"
		    elsif question_id == "10001"
		      answer = "zhu"
		    elsif question_id == "10020"
		      answer = "chirpy"
		    elsif question_id == "10022"
		      answer = "hamedan"
		    end
		    req = Net::HTTP::Post.new(securityUri, {"Cookie" => cookies})
		    req.set_form_data({"utf8" => "✓", "authenticity_token" => authenticityToken, "answer" => answer, "question_id" => question_id, "commit" => "Continue"})
		    resp = http.request(req)
		    cookies = resp.response["set-cookie"]
		    dashboardUri = "/dashboard/"
		    req = Net::HTTP::Get.new(dashboardUri, {"Cookie" => cookies})
		    resp = http.request(req)
		    resp = resp.body
		    ratesUri = "/rates/csv.csv"
		    req = Net::HTTP::Get.new(ratesUri, {"Cookie" => cookies})
		    resp = http.request(req)
		    resp = resp.body
		    ratesCsv = CSV.parse(resp, :headers => true)
		    us_id = Country.find_by_alpha2("US").id
		    mx_id = Country.find_by_alpha2("MX").id
		else
			ratesCsv = CSV.read("db/wholesaler_rates/idt.dev.csv", :headers => true)
		end

	    ratesCsv.each do |row|
	    	params = row.to_hash
	    	region = Region.find_by_sql("SELECT * FROM regions WHERE '" +
	        	params["Code"] + "' LIKE prefix || '%' ORDER BY prefix DESC LIMIT 1;").first;

	    	min_charge = "1"
	    	billing_increment = "1"
	    	if region.country_id == mx_id
	    		min_charge = "60"
	        	billing_increment = "60"
	    	elsif region.country_id == us_id
	       		min_charge = "6"
	         	billing_increment = "6"
	    	end

	    	if Rails.env == "production"
	    		WholesalerRate.create!({
		    		:description => params["Location"].encode('utf-8', 'iso-8859-1'),
		    		:rate => Rails.env == "production" ? params["Bronze"][1..-1] : params["Bronze"],
		        	:billing_increment => billing_increment,
		        	:min_charge => min_charge,
		        	:wholesaler_id => wholesaler.id,
		        	:category => region.category,
		        	:country_id => region.country_id,
		        	:version => version,
		        	:prefix => params["Code"],
		        	:wholesaler_id => wholesaler.id
		    	})
	    	else
		    	rate = WholesalerRate.find_or_initialize_by_prefix_and_wholesaler_id(params["Code"], wholesaler.id)
		    	rate.update_attributes!({
		    		:description => params["Location"].encode('utf-8', 'iso-8859-1'),
		    		:rate => Rails.env == "production" ? params["Bronze"][1..-1] : params["Bronze"],
		        	:billing_increment => billing_increment,
		        	:min_charge => min_charge,
		        	:wholesaler_id => wholesaler.id,
		        	:category => region.category,
		        	:country_id => region.country_id
		    	})
		    end
		end
	end
end
