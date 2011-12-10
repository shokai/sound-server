before do
  @title = @@conf['title']
end

get '/' do
  haml :index
end

get '/:name/upload' do
  @name = params[:name]
  haml :sound_upload
end
