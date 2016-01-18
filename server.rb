require 'sinatra'
require 'soundcloud'
require 'dotenv'
require 'byebug'

Dotenv.load

require_relative 'helpers/helper_methods'

get '/' do
	
	puts 'here'
	puts soundcloud_connect
	client = soundcloud_connect
	
	# client =	authenticate_user
	# redirect_to client.authorize_url()

	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	@stream = client.get('/me/activities/tracks/affiliated', :limit => 200)
	stream_tracks = @stream.collection
	
	tracks = downloadable_tracks(stream_tracks)
	@filtered = only_public(tracks)

	urls = download_urls(@filtered)
	@downloadable_stream = embed_playlist(urls)

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
	filtered = only_public(tracks)

	urls = download_urls(filtered)
	@second_downloadable = embed_playlist(urls)

	erb :page_2
end

get '/on_it' do

	client = soundcloud_connect
	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	first_stream = client.get('/me/activities/tracks/affiliated', :limit => 200)
	second = client.get('/me/activities/tracks/affiliated', :limit => 200,  :linked_partitioning => 1)
	href = second.next_href
	second_stream = client.get(href)

	total_tracks = first_stream.collection + second_stream.collection
	downloadable = downloadable_tracks(total_tracks)
	filter = only_public(downloadable)
	order = most_downloaded(filter)

	urls = download_urls(order)
	@ordered = embed_playlist(urls)

	puts order.length
	puts order.first["origin"]["playback_count"]
	puts order.last["origin"]["playback_count"]

	erb :on_it
end

