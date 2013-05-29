require "uri"
require "net/http"
require "csv"

class Wholesaler < ActiveRecord::Base
  attr_accessible :auth_id, :auth_secret, :ip, :name, :password, :username
  has_many :wholesaler_rates

  def self.updateGafachiRates
    # For later
    # WholesalerRate.find_by_sql("Select rate FROM wholesaler_rates INNER JOIN wholesaler_prefixes ON wholesaler_rates.id=wholesaler_prefixes.wholesaler_rate_id WHERE '35124911' LIKE (wholesaler_prefixes.prefix || '%') ORDER BY wholesaler_prefixes.prefix DESC LIMIT 1")
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
    ActiveRecord::Base.transaction do
      ratesCsv.each do |row|
        params = row.to_hash
        rate = WholesalerRate.create!(
          :country => params["Country"].encode('utf-8', 'iso-8859-1'),
          :description => params["Description"].encode('utf-8', 'iso-8859-1'),
          :rate => params["Rate per minute"][1..-1],
          :billing_increment => params["Billing increment (in seconds)"],
          :min_charge => params["Minimum charge period (in seconds)"],
          :wholesaler_id => 1)
        if !params["Prefixes"]
          WholesalerPrefix.create!(:prefix => params["CountryCode"], :wholesaler_rate_id => rate.id)
        else
          prefixes = params["Prefixes"].split("&")
          prefixes.each do |prefix|
            WholesalerPrefix.create!(:prefix => params["CountryCode"] + prefix, :wholesaler_rate_id => rate.id)
          end
        end
      end
    end
  end
end
