require 'data_mapper'
require './data_mapper_setup'

task :auto_upgrade do
	DataMapper.auto_upgrade!
	puts "Auto upgrade complete"
end

task :auto_migrate do
	DataMapper.auto_migrate!
	puts "Auto migrate complete"
end