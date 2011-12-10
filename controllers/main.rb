get '/' do
  @title = @@conf['title']
  haml :index
end

