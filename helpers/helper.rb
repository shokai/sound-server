
def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

def file_dir
  "#{File.dirname(__FILE__)}/../public/files"
end

def file_url
  "#{app_root}/files"
end

