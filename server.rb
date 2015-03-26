require 'sinatra'
require 'soundcloud'

get '/' do
	# client = Soundcloud.new(:client_id => '719a768af3a4fe513bfac11c4c81e408',
 #                        	:client_secret => '872801e4558afd4a973eafb3d65f3e65',
 #                        	:redirect_uri => 'http://localhost:9292/')
	# redirect user to authorize URL
	# redirect client.authorize_url()
  erb :index
end
