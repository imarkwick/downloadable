require 'sinatra'
require 'soundcloud'
require 'dotenv'
require 'byebug'

Dotenv.load

require_relative 'helpers/helper_methods'

get '/' do
	
	client = soundcloud_connect

	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	@stream = client.get('/me/activities/tracks/affiliated', :limit => 200)
	stream_tracks = @stream.collection
	
	tracks = downloadable_tracks(stream_tracks)
	
	filtered = only_public(tracks)

	urls = download_urls(filtered)

	@downloadable_stream = embed_playlist(urls)

	# test = most_downloaded(tracks)

	erb :index
end

get '/page_2' do

	client = soundcloud_connect

	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	second_stream = client.get('/me/activities/tracks/affiliated', :limit => 200,  :linked_partitioning => 1)
	href = second_stream.next_href
	track_listing = client.get(href)
	stream_next_tracks = track_listing.collection
	
	tracks = downloadable_tracks(stream_next_tracks)
	
	urls = download_urls(tracks)
	@second_downloadable = embed_playlist(urls)

	erb :page_2
end

get '/on_it' do

	client = soundcloud_connect
	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	erb :on_it
end

