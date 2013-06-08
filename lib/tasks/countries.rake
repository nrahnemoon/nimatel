require 'csv'

# Run the following command in production after deploying
# TODO: add this to cap deploy
# /usr/bin/env bundle exec rake countries RAILS_ENV=production
desc "Import countries from csv file"
task :countries => [:environment] do
	CSV.foreach("db/countries/countries.csv", :headers => true)	do |row|
		country = Country.find_or_initialize_by_alpha2(row[1])
		country.update_attributes({
			:name => row[0],
			:alpha3 => row[2],
			:sound_file => row[3],
			:image_file => row[4]
		})
	end
end