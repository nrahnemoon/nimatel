require 'csv'

desc "Import retailers from csv files"
task :import_retailers => [:environment] do
	file = "db/retailers/AK.csv"
	Dir["db/retailers/*"].each { |file|
		CSV.foreach(file, :headers => true)	do |row|
			Retailer.create!({
				:name => row[0],
				:address => row[1],
				:city => row[2],
				:state => row[3],
				:zip => row[4],
				:country => row[5],
				:gender => row[6],
				:phone_number => row[7],
				:fax_number => row[8],
				:contact => row[9],
				:contact_title => row[10],
				:website => row[11],
				:num_employees => row[12],
				:sales => row[13],
				:industry => row[14],
				:sic => row[15],
				:sic_description => row[16],
				:email => row[17]
			})
		end
	}
end