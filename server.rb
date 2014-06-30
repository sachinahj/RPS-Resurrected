require_relative 'lib/RPS.rb'
require 'sinatra'
# require 'sinatra-contrib'

set :bind, '0.0.0.0' # This is needed for Vagrant

get '/' do
  erb :welcome
end
get '/sign_up' do
  @result =  {
    :success? => nil,
    :error => nil,
    :user => nil
  }
  erb :sign_up
end
post '/sign_up' do
  @result = RPS::UserSignUp.run(params)
  if @result[:success?]
    erb :user_homepage
  else
    erb :sign_up
  end
end
get '/sign_in' do
  @result = {
    :success? => nil,
    :error => nil,
    :session_id => nil,
    :user => nil
  }
  erb :sign_in
end
post '/sign_in' do
  @result = RPS::UserSignIn.run(params)
  if @result[:success?]
    erb :user_homepage
  else
    erb :sign_in
  end
end
get '/new_game' do
  p params
  erb :make_move
end
get '/contact' do
  erb :contact
end
# post '/sign_up' do
#   puts params
#   @name = params[:name]
#   @email = params[:mail]
#   @vegetarian = params[:vegetarian]
#   @blood_type = params[:bloodtype]
#   erb :summary
# end
