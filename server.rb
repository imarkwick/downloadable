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

	stream_tracks = @stream.collection
	
	new_downloadable_tracks = downloadable_only(stream_tracks)
	downloadable_urls = download_urls(new_downloadable_tracks)

	@downloadable_stream = embed_playlist(downloadable_urls)

	puts stream_tracks.length
	puts new_downloadable_tracks.first.created_at

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

	next_downloadable = downloadable_only(stream_next_tracks)
	next_urls = download_urls(next_downloadable)

	@second_downloadable = embed_playlist(next_urls)

	puts stream_next_tracks.length
	puts next_downloadable.first.created_at

	erb :page_2
end
