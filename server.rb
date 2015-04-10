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

	stream = @client.get('/me/activities/tracks/affiliated', :limit => 100)
	stream_tracks = stream.collection
	@tracks_array = stream_url_array(stream_tracks)

	puts stream_tracks.first
	puts '-----------------'
	puts stream_url_array(stream_tracks)

	test_track_url = 'http://soundcloud.com/joehertz/tears'
	@embed_info = @client.get('/oembed', :url => test_track_url)
	# puts @embed_info['html']	
	# puts @embed_info.is_a?(Hash)

	erb :index
end

get '/downloadable' do
	# send_file 'index.html'
end
