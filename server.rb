require 'sinatra'
require 'soundcloud'
require 'dotenv'

Dotenv.load

require_relative 'helper_methods'

set :views, Proc.new { File.join(root) } 

get '/' do
	
	soundcloud_connect
	
	@username = @client.get('/me').username
	@following_count = @client.get('/me/').followings_count

	@tracks = @client.get('/users/952969/tracks')
	id = @client.get('/me').id

	@downloadable = downloadable_urls

	@stream = @client.get('/me/activities/tracks/affiliated', :limit => 1)

	puts @stream.has_key?("collection")
	puts '-----------------'
	puts @stream.collection[0].has_key?("title")

	test_track_url = 'http://soundcloud.com/joehertz/tears'
	@embed_info = @client.get('/oembed', :url => test_track_url)
	# puts @embed_info['html']	
	# puts @embed_info.is_a?(Hash)

	erb :index
end

# URL for Joe's soundcloud stream:
# https://api.soundcloud.com/me/activities/tracks/affiliated?limit=100&oauth_token=719a768af3a4fe513bfac11c4c81e408

get '/downloadable' do
	# send_file 'index.html'
end
