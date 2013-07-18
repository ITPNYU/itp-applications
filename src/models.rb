require 'data_mapper'
require 'dm-postgres-adapter'
require 'will_paginate'
require 'will_paginate/data_mapper'

DataMapper.setup(:default,
  ENV['DATABASE_URL'] || "postgres://localhost/itpapplications")

# Set String length, DataMapper's default is 50.
DataMapper::Property::String.length(255)

DataMapper.finalize

if ENV['RACK_ENV'] != 'production'
  # Require all files in ./src/models so that you can start an IRB session and
  # simply require this file.
  Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file }
  DataMapper.auto_upgrade!
end