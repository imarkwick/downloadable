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
	tracks_only = remove_mixes(new_downloadable_tracks)
	urls = download_urls(tracks_only)

	@downloadable_stream = embed_playlist(urls)
	
	puts new_downloadable_tracks.length
	puts tracks_only.length

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
	tracks_only = remove_mixes(next_downloadable)
	urls = download_urls(tracks_only)

	@second_downloadable = embed_playlist(urls)

	puts next_downloadable.length
	puts tracks_only.length

	erb :page_2
end
