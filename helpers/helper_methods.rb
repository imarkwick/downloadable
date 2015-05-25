def soundcloud_connect
	SoundCloud.new(
		:client_id 			=> ENV['CLIENT_ID'],
		:client_secret 	=> ENV['CLIENT_SECRET'],
		:username				=> ENV['USERNAME'],
		:password				=> ENV['PASSWORD']	
	)
end

def authenticate_user
	Soundcloud.new(
		:client_id 			=> ENV['CLIENT_ID'],
		:client_secret 	=> ENV['CLIENT_SECRET'],
		:redirect_uri 	=> ENV['REDIRECT_URL']
	)
end

def stream_url_array(tracks_array)
	tracks_array.select { |track| track["origin"]["permalink_url"] }
end

def downloadable_only(tracks_array)
	tracks_array.select { |track| track["origin"]["downloadable"] }
end

def download_urls(tracks)
	good_urls = []
	tracks.each { |track| good_urls << track["origin"]["permalink_url"] }
	good_urls
end

def embed_info(track_url)
	client = soundcloud_connect
	track = client.get('/oembed', :url => track_url)
	html = track['html']
end

def embed_playlist(track_urls)
	iframe_array = []
	track_urls.each do |url|
		# puts "Embedding " + url
		iframe_array << embed_info(url)
	end
	iframe_array
end

def remove_mixes(tracks)
	only_tracks = []
	tracks.each { |track| only_tracks << track if track["origin"]["duration"] < 720000 }
	only_tracks
end

def only_public(tracks)
	tracks.select { |track| track["origin"]["sharing"] == "public" }
end

def downloadable_tracks(stream_tracks)
	downloadable = downloadable_only(stream_tracks)
	minus_mixes = remove_mixes(downloadable)
	minus_mixes
end

def most_downloaded(tracks)
	list = tracks.sort_by { |k, v| k["origin"]["download_count"] }
	list.reverse
end

def show_titles(tracks)
	titles = []
	tracks.each { |track| titles << track["origin"]["permalink_url"] }
	titles
end


