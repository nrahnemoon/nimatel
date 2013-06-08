require 'csv'

# Run the following command in production after deploying
# TODO: add this to cap deploy
# /usr/bin/env bundle exec rake region RAILS_ENV=production
desc "Import regions from csv file"
task :regions => [:environment] do
	CSV.foreach("db/numbering_plans/numbering_plans.csv", :headers => true)	do |row|
		country = Country.find_by_alpha2(sanitize(row[3]))
		if !country
			country = Country.create!({
				:name => sanitize(row[7]),
				:alpha2 => sanitize(row[3]),
				:alpha3 => sanitize(row[4])
			})
		end
		region = Region.find_or_initialize_by_prefix(sanitize(row[0]))
		region.update_attributes({
			:name => sanitize(row[10]),
			:country_id => country.id,
			:category => Region::CATEGORIES_CONVERSION[sanitize(row[8])],
			:registrar => sanitize(row[11])
		})
	end
end

def sanitize(word)
	word = word && word.starts_with?("'") ? word[1..-1] : word
	word = word && word.ends_with?("'") ? word[0..-2] : word
end
