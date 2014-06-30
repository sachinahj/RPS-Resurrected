require_relative 'lib/RPS.rb'
require 'sinatra'
require 'pry'
# require 'sinatra-contrib'

enable :sessions 

set :bind, '0.0.0.0' # This is needed for Vagrant

get '/' do
  erb :welcome
end

get '/sign_up' do
  @result =  {
    :success? => nil,
    :error => nil,
    :sesh_id => nil,
    :user => nil
  }
  erb :sign_up
end

post '/sign_up' do
  @result = RPS::UserSignUp.run(params)
  if @result[:success?]
    session[:sesh_id] = @result[:user].session_id
    session[:user_id] = @result[:user].id
    redirect to '/user_homepage'
  else
    erb :sign_up
  end
end

get '/sign_in' do
  if session[:sesh_id]
    user = RPS::User.get_user_object_by_session_id(session[:sesh_id])
    session[:sesh_id] = user.session_id
    session[:user_id] = user.id
    redirect to '/user_homepage'
  else
    @result = {
      :success? => nil,
      :error => nil,
      :sesh_id => nil,
      :user => nil
    }
    erb :sign_in
  end
end

post '/sign_in' do
  @result = RPS::UserSignIn.run(params)
  if @result[:success?]
    session[:sesh_id] = @result[:sesh_id]
    session[:user_id] = @result[:user].id
    redirect to '/user_homepage'
  else
    erb :sign_in
  end
end

get '/new_game' do
  @user = RPS::User.get_user_object_by_user_id(session[:user_id])
  @match = RPS::Match.new(@user)
  @match.create!
  @match.assign_random_opponent
  @match.save!
  @user1 = @match.user1
  @user2 = @match.user2

  if @user.id == @user1.id
    user_index = 0 
    opponent_index = 1
  end
  if @user.id == @user2.id
    user_index = 1
    opponent_index = 0
  end

  session[:match_id] = @match.match_id
  session[:user_index] = user_index
  session[:opponent_index] = opponent_index

  erb :match_homepage
end

get '/continue_game' do
  @user = RPS::User.get_user_object_by_user_id(session[:user_id])
  @match = RPS::Match.get_match_object_by_match_id(session[:match_id])
  @user1 = @match.user1
  @user2 = @match.user2

  if @user.id == @user1.id
    user_index = 0 
    opponent_index = 1
  end
  if @user.id == @user2.id
    user_index = 1
    opponent_index = 0
  end

  session[:user_index] = user_index
  session[:opponent_index] = opponent_index

  erb :match_homepage
end

post '/made_move' do
  match = RPS::Match.get_match_object_by_match_id(session[:match_id])
  match.user1_move = params["choice"] if session[:user_index] == 0
  match.user2_move = params["choice"] if session[:user_index] == 1
  match.save!

  if match.moves_made? == [true, true]
    winner = match.game_winner
    match.add_to_history
    match.clear_moves
    match.save!
  end

  match.game_over?
  match.save!
  redirect to '/continue_game'
end

get '/user_homepage' do
  @user = RPS::User.get_user_object_by_user_id(session[:user_id])
  erb :user_homepage
end

get '/logout' do
  session.clear
  redirect to '/'
end

get '/contact' do
  erb :contact
end
