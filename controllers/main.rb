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

get '/:user' do
  @user = params[:user]
  @sounds = Sound.where({:user => @user}).desc(:uploaded_at)
  haml :sound_list
end

get '/:user/:hex_id' do
  @user = params[:user]
  @hex_id = params[:hex_id]
  @s = Sound.where({:user => @user, :hex_id => @hex_id}).first
  unless @s
    status 404
    @mes = 'not found'
  else
    haml :sound
  end
end
