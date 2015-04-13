require 'sinatra'
require 'soundcloud'
require 'dotenv'

Dotenv.load

require_relative 'helpers/helper_methods'

set :views, Proc.new { File.join(root) } 

get '/' do
	
	client = soundcloud_connect
	
	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	@stream = client.get('/me/activities/tracks/affiliated', :limit => 200)
	# @second_stream = client.get('/me/activities/tracks/affiliated', :limit => 200,  :linked_partitioning => 1)

	stream_tracks = @stream.collection

	puts stream_tracks.first
	# puts @second_stream.next_href
	
	new_downloadable_tracks = downloadable_only(stream_tracks)
	downloadable_urls = download_urls(new_downloadable_tracks)

	@downloadable_stream = embed_playlist(downloadable_urls)

	erb :index
end

get '/page_2' do

	client = soundcloud_connect

	second_stream = client.get('/me/activities/tracks/affiliated', :limit => 200,  :linked_partitioning => 1)

	next_tracks = second_stream.next_href
	# next_collection = next_tracks.collection

	puts next_tracks.is_a?(Object)

	erb :page_2
end
