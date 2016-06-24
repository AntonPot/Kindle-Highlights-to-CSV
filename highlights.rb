require 'rubygems'
require 'sinatra'
require 'shotgun'

require_relative './parser.rb'

get '/' do
  erb :index
end

post '/form' do
  # filename = 'kindle_highlights.csv'
  filename = 'kindle_highlights_hash'
  data = Parser::Kindle.new(params[:email], params[:password]).books_highlights
  p data
  File.open(filename, "w") { |file| file.write(data) }
  # Parser::CsvGenerator.go( data, filename )
  redirect "/download/#{filename}"
end

get '/download/:filename' do |filename|
  @fname = filename
  send_file "./#{filename}", :filename => filename, :type => 'Application/octet-stream'
end
