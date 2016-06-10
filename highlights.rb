require 'rubygems'
require 'sinatra'
require 'shotgun'
require 'dotenv'

require_relative './parser.rb'

Dotenv.load

get '/' do
  erb :index
end

post '/form' do
  filename = 'kindle_highlights.csv'
  email = params[:email]
  password = params[:password]
  data = Parser::Kindle.new(email, password).books_highlights
  Parser::CsvGenerator.go( data, filename )
  redirect "/download/#{filename}"
end

get '/download/:filename' do |filename|
  @fname = filename
  send_file "./#{filename}", :filename => filename, :type => 'Application/octet-stream'
end
