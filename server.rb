require 'sinatra'
require 'soundcloud'
require 'dotenv'
require 'byebug'

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Dotenv.load

require_relative 'helpers/helper_methods'

get '/' do
	
	client = soundcloud_new

	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	@stream = client.get('/me/activities/tracks/affiliated', :limit => 200)
	stream_tracks = @stream.collection

	tracks = downloadable_tracks(stream_tracks)
	@filtered = only_public(tracks)

	urls = download_urls(@filtered)
	@downloadable_stream = embed_playlist(urls, client)

	erb :index
end

get '/page_2' do

	client = soundcloud_new

	@username = client.get('/me').username
	@following_count = client.get('/me/').followings_count

	second_stream = client.get('/me/activities/tracks/affiliated', :limit => 200,  :linked_partitioning => 1)
	href = second_stream.next_href
	track_listing = client.get(href)
	stream_next_tracks = track_listing.collection
		
	tracks = downloadable_tracks(stream_next_tracks)

	filtered = only_public(tracks)

	urls = download_urls(filtered)
	@second_downloadable = embed_playlist(urls, client)

	erb :page_2
end

get '/on_it' do

	client = soundcloud_new

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

private

def soundcloud_new
	SoundCloud.new({
		:client_id 			=> 'e49d27008e32d20179f085a5f6847c5c',
		:client_secret 	=> '74adc0e1f7ce90fd6c1420e88195a105',
		:username				=> 'joetong1@me.com',
		:password				=> 'Michael1990'
	})
end


