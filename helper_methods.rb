def soundcloud_connect
	@client = SoundCloud.new(
		:client_id 			=> ENV['CLIENT_ID'],
		:client_secret 	=> ENV['CLIENT_SECRET'],
		:username				=> ENV['USERNAME'],
		:password				=> ENV['PASSWORD']
	)
end

def user_track_urls(tracks)
	@track_urls = []
	tracks.each { |track| @track_urls << track.permalink_url }
	@track_urls
end

def downloadable
	@downloadable_tracks = @tracks.select { |track| track.downloadable }
end

def downloadable_urls
	user_track_urls(downloadable)
end


