
def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

def file_dir(name='share')
  name = 'share' if name.to_s.size < 1
  "#{File.dirname(__FILE__)}/../public/files/#{name}"
end

def file_url(name='share')
  name = 'share' if name.to_s.size < 1
  "#{app_root}/files/#{name}"
end
