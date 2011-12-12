before do
  @title = @@conf['title']
end

get '/' do
  haml :index
end

get '/api' do
  haml :api
end

get '/:user/upload' do
  @user = params[:user]
  haml :sound_upload
end

get '/:user.json' do
  @user = params[:user]
  content_type = 'application/json'
  @mes = Sound.where({:user => @user}).desc(:uploaded_at).map{|s|
    h = s.to_hash
    h[:file] = "#{app_root}/files/#{h[:file]}"
    h
  }.to_json
end

get '/:user' do
  @user = params[:user]
  @sounds = Sound.where({:user => @user}).desc(:uploaded_at)
  haml :sound_list
end

get '/:user/:hex_id.json' do
  @user = params[:user]
  @hex_id = params[:hex_id]
  content_type = 'application/json'
  @s = Sound.where({:user => @user, :hex_id => @hex_id}).first
  unless @s
    status 404
    @mes = 'not fount'
  else
    h = @s.to_hash
    h[:file] = "#{app_root}/files/#{h[:file]}"
    h.to_json
  end
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
