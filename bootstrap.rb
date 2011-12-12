require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra/reloader' if development?
require 'yaml'
require 'json'
require 'haml'
require 'fileutils'
require 'mongoid'
require 'digest/md5'
require 'mini_exiftool'
require 'igo-ruby'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p @@conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
  exit 1
end

[:helpers, :models ,:controllers].each do |dir|
  Dir.glob(File.dirname(__FILE__)+"/#{dir}/*.rb").each do |rb|
    puts "loading #{rb}"
    require rb
  end
end

set :haml, :escape_html => true

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo']['server'], @@conf['mongo']['port']).db(@@conf['mongo']['dbname'])
}
