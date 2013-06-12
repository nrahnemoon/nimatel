require 'csv'

# Run the following command in production after deploying
# TODO: add this to cap deploy
# /usr/bin/env bundle exec rake init RAILS_ENV=production
desc "Initialize all data"
task :init => [
	:environment,
	:countries,
	:regions,
	:wholesalers,
	"rates:gafachi",
	"rates:idt",
	:rates] do
end
