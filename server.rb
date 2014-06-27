require 'sinatra'
require 'sinatra-contrib'

set :bind, '0.0.0.0' # This is needed for Vagrant

get '/' do
  "landing page"
end

post '/test' do
  puts params
  @name = params[:name]
  @email = params[:mail]
  @vegetarian = params[:vegetarian]
  @blood_type = params[:bloodtype]
  erb :summary
end

get '/dog-registration' do
  puts params
end
