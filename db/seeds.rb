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
