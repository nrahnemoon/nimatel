require 'csv'

# Run the following command in production after deploying
# TODO: add this to cap deploy
# /usr/bin/env bundle exec rake countries RAILS_ENV=production
desc "Calculate rates"
task :rates => [:environment, :regions, "rates:gafachi", "rates:idt"] do
		Country.all.each { |country|
			landline_rate = nil
			mobile_rate = nil
			satellite_rate = nil

			Wholesaler.all.each { |wholesaler|
				version = WholesalerRate.where({ :wholesaler_id => wholesaler.id}).count == 0 ? nil : WholesalerRate.find_by_sql(
					"SELECT version FROM wholesaler_rates WHERE wholesaler_id = " + wholesaler.id.to_s +
					" ORDER BY version DESC LIMIT 1").first.version

				# Algorithm 1 for determining cost (aka the default algorithm)
				landline_category_rates = calculateRatesByCategories(country, wholesaler, version, Region::CATEGORIES_LANDLINE, "landline")
				mobile_category_rates = calculateRatesByCategories(country, wholesaler, version, Region::CATEGORIES_MOBILE, "mobile")
				satellite_category_rates = calculateRatesByCategories(country, wholesaler, version, Region::CATEGORIES_SATELLITE, "satellite")

				# Algorithm 2 for determining cost (aka the checker algorithm)
				landline_description_rates = calculateLandlineRatesByDescription(country, wholesaler, version)
				mobile_description_rates = calculateMobileRatesByDescription(country, wholesaler, version)
				satellite_description_rates = calculateSatelliteRatesByDescription(country, wholesaler, version)

				# Log discrepancies between categorical rate and description rate
				logCategoricalDescriptionRateDiscrepancies(
					"landline", country.name, wholesaler.name, landline_category_rates[0], landline_description_rates[0])
				logCategoricalDescriptionRateDiscrepancies(
					"mobile", country.name, wholesaler.name, mobile_category_rates[0], mobile_description_rates[0])
				logCategoricalDescriptionRateDiscrepancies(
					"satellite", country.name, wholesaler.name, satellite_category_rates[0], satellite_description_rates[0])
				logAverageRateDiscrepancies(
					"categorical landline", country.name, wholesaler.name, landline_category_rates[0], landline_category_rates[1])
				logAverageRateDiscrepancies(
					"categorical mobile", country.name, wholesaler.name, mobile_category_rates[0], mobile_category_rates[1])
				logAverageRateDiscrepancies(
					"categorical satellite", country.name, wholesaler.name, satellite_category_rates[0], satellite_category_rates[1])
				logAverageRateDiscrepancies(
					"description landline", country.name, wholesaler.name, landline_description_rates[0], landline_description_rates[1])
				logAverageRateDiscrepancies(
					"description mobile", country.name, wholesaler.name, mobile_description_rates[0], mobile_description_rates[1])
				logAverageRateDiscrepancies(
					"description satellite", country.name, wholesaler.name, satellite_description_rates[0], satellite_description_rates[1])

				if landline_category_rates[0] && (landline_rate == nil || landline_category_rates[0] < landline_rate)
					landline_rate = landline_category_rates[0]
				end

				if mobile_category_rates[0] && (mobile_rate == nil || mobile_category_rates[0] < mobile_rate)
					mobile_rate = mobile_category_rates[0]
				end

				if satellite_category_rates[0] && (satellite_rate == nil || satellite_category_rates[0] < satellite_rate)
					satellite_rate = satellite_category_rates[0]
				end
			}
			# Update country with new rate costs
			country.update_attributes!({
				:landline_rate => landline_rate,
				:mobile_rate => mobile_rate,
				:satellite_rate => satellite_rate
			})
		}
end

def logAverageRateDiscrepancies(rateType, countryName, wholesalerName, maxRate, averageRate)
	if maxRate && averageRate && ((maxRate - averageRate).abs/maxRate > 0.25)
		logMessage = wholesalerName.capitalize + " " + countryName + " " + rateType +
			": maxRate(" + maxRate.to_s + ") - avgRate (" + averageRate.to_s + ") > 25%"
		Rails.logger.error logMessage
		puts logMessage
	end
end

def logCategoricalDescriptionRateDiscrepancies(rateType, countryName, wholesalerName, categoryRate, descriptionRate)
	if categoryRate && descriptionRate && (categoryRate != descriptionRate)
		logMessage = wholesalerName.capitalize + " " + countryName + " " + rateType +
			": catRate(" + categoryRate.to_s + ") != descRate(" + descriptionRate.to_s + ")"
		Rails.logger.error logMessage
		puts logMessage
	end
end

def calculateRatesByCategories(country, wholesaler, version, categories, rateType)
	sql = "SELECT rate FROM wholesaler_rates WHERE country_id = " + country.id.to_s +
		" AND wholesaler_id = " + wholesaler.id.to_s + " AND category IN (" + categories.join(", ") + ")"
	sql += version == nil ? ";" : " AND version = " + version.to_s + ";"
	rates = WholesalerRate.find_by_sql(sql)
	return calculateMaxAvgRate(country, wholesaler, rates, rateType, "categorical")
end

def calculateLandlineRatesByDescription(country, wholesaler, version)
	sql = "SELECT rate FROM wholesaler_rates WHERE country_id = " + country.id.to_s +
		" AND wholesaler_id = " + wholesaler.id.to_s +
		" AND description NOT LIKE '%mobile%' AND description NOT LIKE '%Mobile%' AND description NOT LIKE '%cellular%'" +
		" AND description NOT LIKE '%Cellular%' AND description NOT LIKE '%Satellite%' AND description NOT LIKE '%satellite%'"
	sql += version == nil ? ";" : " AND version = " + version.to_s + ";"
	rates = WholesalerRate.find_by_sql(sql)
	return calculateMaxAvgRate(country, wholesaler, rates, "landline", "description")
end

def calculateMobileRatesByDescription(country, wholesaler, version)
	sql = "SELECT rate FROM wholesaler_rates WHERE country_id = " + country.id.to_s +
		" AND wholesaler_id = " + wholesaler.id.to_s +
		" AND (description LIKE '%mobile%' OR description LIKE '%Mobile%' OR description LIKE '%cellular%'" +
		" OR description LIKE '%Cellular%')"
	sql += version == nil ? ";" : " AND version = " + version.to_s + ";"
	rates = WholesalerRate.find_by_sql(sql)
	return calculateMaxAvgRate(country, wholesaler, rates, "mobile", "description")
end

def calculateSatelliteRatesByDescription(country, wholesaler, version)
	sql = "SELECT rate FROM wholesaler_rates WHERE country_id = " + country.id.to_s +
		" AND wholesaler_id = " + wholesaler.id.to_s +
		" AND (description LIKE '%satellite%' OR description LIKE '%Satellite%')"
	sql += version == nil ? ";" : " AND version = " + version.to_s + ";"
	rates = WholesalerRate.find_by_sql(sql)
	return calculateMaxAvgRate(country, wholesaler, rates, "satellite", "description")
end

def calculateMaxAvgRate(country, wholesaler, rates, rateType, algorithm)
	maxRate = rates.length == 0 ? nil : rates.collect(&:rate).delete_if{ |x| x == nil}.max
	averageRate = rates.length == 0 ? nil : rates.collect(&:rate).delete_if{ |x| x == nil}.sum / rates.length
	if rates.length == 0
		logMessage = wholesaler.name.capitalize + "'s " + algorithm + " rate for " + country.name +
			" " + rateType + " does not exist."
		Rails.logger.info logMessage
		puts logMessage
	end
	return [maxRate, averageRate]
end
