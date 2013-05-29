# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Seeding..."

# Disable attr_accessible in seed
module ActiveModel
  module MassAssignmentSecurity
    class Sanitizer
      def sanitize(attributes, authorizer)
        attributes
      end
    end
  end
end

Wholesaler.create(
	:name => "Gafachi",
	:ip => "67.216.35.226",
	:username => "nimatel",
	:password => "g4f4ch1",
	:auth_id => "a13959szfh8dNATl",
	:auth_secret => "rSsXzt08PB8zlUdq"
)

Country.create(
  :id => 1,
  :name => "Afghanistan",
  :country_code => "",
  :sound_file => "",
  :image_file => ""
)