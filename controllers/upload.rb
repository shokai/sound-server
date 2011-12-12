

post '/:user/upload_text' do
  user = params[:user]
  text = params[:text]
  unless text
    status 400
    @mes = 'speech text missing'
  else
    puts m = text.gsub(/[`"'\r\n;]/, '').strip.to_kana
    if m.size < 1
      status 400
      @mes = 'speech text missing'
    else
      tmp_fname = "#{file_dir}/#{Time.now.to_i}_#{Time.now.usec}"
      puts cmd = "#{@@conf['saykana']} '#{m}' -o #{tmp_fname}"
      system cmd
      hex = Digest::MD5.hexdigest(open(tmp_fname).read)
      s = Sound.where({:hex_id => hex}).first
      s = Sound.new({:hex_id => hex}) unless s
      s.file_type = @@conf['file_type']
      fpath = "#{file_dir}/#{s.file}"
      unless File.exists? fpath
        puts cmd = "#{@@conf['ffmpeg']} -y -i #{tmp_fname} -ac 2 -ar 48000 -ab 96 #{fpath}"
        system cmd
      end
      File.delete tmp_fname if File.exists? tmp_fname
      s.user = user
      exif = MiniExiftool.new fpath
      s.length = exif['Duration'].to_f
      s.mime_type = exif['mime_type']
      s.uploaded_at = Time.now.to_i
      s.save
      if params[:no_redirect]
        status 200
        @mes = "#{app_root}/#{s.user}/#{s.hex_id}"
      else
        redirect "#{app_root}/#{s.user}/#{s.hex_id}"
      end
    end
  end
end

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
      s.length = exif['Duration'].to_f
      file_type = exif['FileType'].downcase
      s.file_type = @@conf['file_type']
      unless s.mime_type =~ /^audio\/.+/i
        status 400
        @mes = "#{s.mime_type} is not audio file"
      else
        s.uploaded_at = Time.now.to_i
        fpath = "#{file_dir}/#{s.file}"
        unless File.exists? fpath
          if file_type != 'mp3'
            puts cmd = "#{@@conf['ffmpeg']} -y -i #{tmp_fname} -sameq #{fpath}"
            system cmd
          else
            File.rename(tmp_fname, fpath)
          end
        else
          File.delete(tmp_fname)
        end

        s.save
        if params[:no_redirect]
          status 200
          @mes = "#{app_root}/#{s.user}/#{s.hex_id}"
        else
          redirect "#{app_root}/#{s.user}/#{s.hex_id}"
        end
      end
    end
  end
end

