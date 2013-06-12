require 'csv'

# Run the following command in production after deploying
# TODO: add this to cap deploy
# /usr/bin/env bundle exec rake countries RAILS_ENV=production
desc "Calculate rates"
task :rates => [:environemnt, :regions] do
	# landline_rates.collect(&:rate).sum.to_f / landline_rates.length if landline_rates.length > 0
	if Rails.env == "production"
		Country.all.each { |country|
			landline_rates = WholesalerRate.find_by_sql("SELECT rate FROM wholesaler_rates WHERE country_id=" + country.id.to_s +
				" AND category IN (" + Region::CATEGORIES_LANDLINE.join(", ") + ")")
		}
	else
		Country.all.each { |country|
			landline_rates = WholesalerRate.find_by_sql("SELECT rate FROM wholesaler_rates WHERE country_id = " + country.id.to_s +
				" AND description NOT LIKE '%mobile%' AND description NOT LIKE '%Mobile%' AND description NOT LIKE '%cellular%'" +
				" AND description NOT LIKE '%Cellular%' AND description NOT LIKE '%Satellite%' AND description NOT LIKE '%satellite%';")
			mobile_rates = WholesalerRate.find_by_sql("SELECT rate FROM wholesaler_rates WHERE country_id = " + country.id.to_s +
				" AND (description LIKE '%mobile%' OR description LIKE '%Mobile%' OR description LIKE '%cellular%'" +
				" OR description LIKE '%Cellular%');")
			satellite_rates = WholesalerRate.find_by_sql("SELECT rate FROM wholesaler_rates WHERE country_id = " + country.id.to_s +
				" AND (description LIKE '%satellite%' OR description LIKE '%Satellite%');")
			country.update_attributes({
				:landline_rate => landline_rates.length == 0 ? nil : landline_rates.collect(&:rate).max,
				:mobile_rate => mobile_rates.length == 0 ? nil : mobile_rates.collect(&:rate).max,
				:satellite_rate => satellite_rates.length == 0 ? nil : satellite_rates.collect(&:rate).max,
			})
		}
	end
end
