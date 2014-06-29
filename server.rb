require 'sinatra'
require 'sinatra-contrib'

set :bind, '0.0.0.0' # This is needed for Vagrant

get '/' do
  erb :layout
end

get '/sign_up' do

end
post '/sign_up' do
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
