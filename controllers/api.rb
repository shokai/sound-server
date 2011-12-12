
post '/:user/upload' do
  user = params[:user]
  if !params[:file]
    status 400
    @mes = 'file not attached'
  else
    FileUtils.mkdir_p file_dir unless File.exists? file_dir
    tmp_fname = "#{file_dir}/#{Time.now.to_i}_#{Time.now.usec}"
    File.open(tmp_fname, 'wb') do |f|
      f.write params[:file][:tempfile].read
    end
    unless File.exists? tmp_fname
      status 500
      @mes = 'upload error'
    else
      hex = Digest::MD5.hexdigest(open(tmp_fname).read)
      s = Sound.where(:hex_id => hex).first
      s = Sound.new(:hex_id => hex) unless s
      s.user = user
      exif = MiniExiftool.new tmp_fname
      s.mime_type = exif['mime_type']
      s.file_type = exif['FileType'].downcase
      s.length = exif['Duration'].to_f
      unless s.mime_type =~ /^audio\/.+/i
        status 400
        @mes = "#{s.mime_type} is not audio file"
      else
        s.uploaded_at = Time.now.to_i
        s.file = "#{s.hex_id}.#{s.file_type}"
        fpath = "#{file_dir}/#{s.file}"
        unless File.exists? fpath
          File.rename(tmp_fname, fpath)
        else
          File.delete(tmp_fname)
        end
        s.save
        if params[:no_redirect]
          status 200
          @mes = "#{file_url}/#{s.file}"
        else
          redirect "#{app_root}/#{s.user}/#{s.hex_id}"
        end
      end
    end
  end
end

