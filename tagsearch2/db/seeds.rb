# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"

CSV.foreach('db/sample.csv') do |row|
  Product.create(:tag => row[0],
               :tag1 => row[1],
               :tag2 => row[2],
               :tag3 => row[3],
               :tag4 => row[4],
               :tag5 => row[5],
               :tag6 => row[6],
               :tag7 => row[7],
               :tag8 => row[8],
               :tag9 => row[9])
end
