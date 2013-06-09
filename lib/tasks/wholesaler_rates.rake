require 'csv'

# Run the following command in production after deploying
# TODO: add this to cap deploy
# /usr/bin/env bundle exec rake region RAILS_ENV=production
desc "Import wholesaler rates from the web"
namespace :rates do
	task :gafachi => [:environment] do
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
      	ratesCsv.each do |row|
      		params = row.to_hash
        	if !params["Prefixes"]
          		rate = WholesalerRate.find_or_initialize_by_prefix(params["CountryCode"])
          		rate.update_attributes({
            		:description => params["Country"].encode('utf-8', 'iso-8859-1') + " " + params["Description"].encode('utf-8', 'iso-8859-1'),
            		:rate => params["Rate per minute"][1..-1],
            		:billing_increment => params["Billing increment (in seconds)"],
            		:min_charge => params["Minimum charge period (in seconds)"],
            		:wholesaler_id => 1
          		})
        	else
         		prefixes = params["Prefixes"].split("&")
          		prefixes.each do |prefix|
            		rate = WholesalerRate.find_or_initialize_by_prefix(params["CountryCode"] + prefix)
            		rate.update_attributes({
              			:description => params["Country"].encode('utf-8', 'iso-8859-1') + " " + params["Description"].encode('utf-8', 'iso-8859-1'),
              			:rate => params["Rate per minute"][1..-1],
              			:billing_increment => params["Billing increment (in seconds)"],
              			:min_charge => params["Minimum charge period (in seconds)"],
              			:wholesaler_id => 1
            		})
          		end
        	end
      	end
	end

	task :idt => [:environment] do
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
	    ratesCsv.each do |row|
	    	params = row.to_hash
	    	country = Country.find_by_sql("SELECT alpha2 FROM countries INNER JOIN regions ON countries.id = regions.country_id WHERE '" +
	        	params["Code"] + "' LIKE CONCAT(prefix, '%') ORDER BY prefix DESC LIMIT 1;")
	    	min_charge = "1"
	    	billing_increment = "1"
	    	if country == "MX"
	    		min_charge = "60"
	        	billing_increment = "60"
	    	elsif country == "US"
	       		min_charge = "6"
	         	billing_increment = "6"
	    	end
	    	rate = WholesalerRate.find_or_initialize_by_prefix(params["Code"])
	    	rate.update_attributes({
	    		:description => params["Location"].encode('utf-8', 'iso-8859-1'),
	    		:rate => params["Bronze"][1..-1],
	        	:billing_increment => billing_increment,
	        	:min_charge => min_charge,
	        	:wholesaler_id => 2
	    	})
		end
	end
end
