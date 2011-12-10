
post '/upload/:name' do
  name = params[:name]
  if !params[:file]
    status 400
    @mes = 'file not attached'
  else
    FileUtils.mkdir_p file_dir(name) unless File.exists? file_dir(name)
    fname = "#{Time.now.to_i}_#{Time.now.usec}"+File.extname(params[:file][:filename])
    File.open("#{file_dir(name)}/#{fname}", 'wb') do |f|
      f.write params[:file][:tempfile].read
    end
    unless File.exists? "#{file_dir(name)}/#{fname}"
      status 500
      @mes = 'upload error'
    else
      status 200
      @mes = "#{file_url(name)}/#{fname}"
    end
  end
end
