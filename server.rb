require 'sinatra'
require 'soundcloud'
require 'dotenv'

Dotenv.load

require_relative 'helpers/helper_methods'

set :views, Proc.new { File.join(root) } 

get '/' do
	
	soundcloud_connect
	
	@username = @client.get('/me').username
	@following_count = @client.get('/me/').followings_count

	@tracks = @client.get('/users/952969/tracks')
	id = @client.get('/me').id

	stream = @client.get('/me/activities/tracks/affiliated', :limit => 200)
	stream_tracks = stream.collection
	
	new_downloadable_tracks = downloadable_only(stream_tracks)
	downloadable_urls = dwnld_urls(new_downloadable_tracks)

	@downloadable_stream = embed_playlist(downloadable_urls)

	erb :index
end

get '/downloadable' do
	# send_file 'index.html'
end
