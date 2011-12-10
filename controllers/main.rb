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

get '/:name/*' do
  @name = params[:name]
  @fname = params[:splat].first.first
  if @fname.to_s.size < 1 or !File.exists?("#{file_dir(@name)}/#{@fname}")
    status 404
    @mes = 'not found'
  else
    content_type = 'text/html'
    haml :sound
  end
end
