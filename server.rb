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

	# puts downloadable_urls

	# client = SoundCloud.new(:client_id => '719a768af3a4fe513bfac11c4c81e408',
	#                       	:client_secret => '872801e4558afd4a973eafb3d65f3e65',
	#                       	:redirect_uri => 'http://localhost:9292/downloadable')
	# redirect client.authorize_url()
	# @code =	client.exchange_token(:code => params[:code])
	erb :index
end

get '/downloadable' do
	# send_file 'index.html'
end
