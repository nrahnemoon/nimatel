# Run the following command in production after deploying
# TODO(nima): add this to cap deploy
# /usr/bin/env bundle exec rake wholesalers RAILS_ENV=production
desc "Import wholesalers"
task :wholesalers => [:environment] do
	wholesaler = Wholesaler.find_or_initialize_by_name("Gafachi")
	wholesaler.update_attributes({
		:id => 1,
		:ip => "67.216.35.226",
		:username => "nimatel",
		:password => "g4f4ch1",
		:auth_id => "a13959szfh8dNATl",
		:auth_secret => "rSsXzt08PB8zlUdq"
	})
	wholesaler = Wholesaler.find_or_initialize_by_name("IDT")
	wholesaler.update_attributes({
		:id => 2,
		:ip => "216.53.4.1",
		:username => "nimatel1",
		:password => "1DT3xpr3ss",
		:auth_id => "a13959szfh8dNATl",
		:auth_secret => "rSsXzt08PB8zlUdq"
	})
end