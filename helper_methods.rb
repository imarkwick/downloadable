def soundcloud_connect
	@client = SoundCloud.new(
		:client_id 			=> ENV['CLIENT_ID'],
		:client_secret 	=> ENV['CLIENT_SECRET'],
		:username				=> ENV['USERNAME'],
		:password				=> ENV['PASSWORD']
	)
end

def track_urls(tracks)
	@track_urls = []
	tracks.each { |track| @track_urls << track.permalink_url }
	@track_urls
end

def downloadable(tracks)
	tracks.select { |track| track.downloadable }
end

def downloadable_urls(tracks)
	track_urls(downloadable(tracks))
end

def public?(tracks)
	tracks.map { |track| track.sharing == "public" }
end

def stream_url_array(tracks_array)
	tracks_array.select { |track| track["origin"]["permalink_url"] }
end

def downloadable_only(tracks_array)
	tracks_array.select { |track| track["origin"]["downloadable"] }
end

def dwnld_urls(tracks)
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
		iframe_array << embed_info(url)
	end
	iframe_array
end

