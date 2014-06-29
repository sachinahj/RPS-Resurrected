require_relative 'databases/database.rb'
require_relative 'entities/user.rb'
require_relative 'entities/match.rb'
require_relative 'scripts/user_sign_in.rb'
require_relative 'scripts/user_sign_up.rb'
require_relative 'scripts/user_home_page.rb'
require_relative 'scripts/new_match.rb'
require_relative 'scripts/continue_match.rb'

# while(true)
  def sign_in_test
    puts "-----------sign in---------"
    print "username: "
    username = gets.chomp
    print "password: "
    password = gets.chomp
    params = {
      username: username.downcase,
      password: password
    }
    params = RPS::UserSignIn.run(params)
    if params[:error] == :no_user_exist
      puts "*no user exist*"
      run
    end
    if params[:error] == :invalid_password
      puts "*invalid password*"
      run
    end
    if params[:success?]
      puts "*success!*"
      RPS::UserHomePage.run(params)
    end
  end

  def sign_up_test
    puts "-----------sign up---------"
    print "username: "
    username = gets.chomp
    print "password: "
    password = gets.chomp
    print "confirm password: "
    password_confirm = gets.chomp
    params = {
      username: username.downcase,
      password: password,
      password_confirm: password_confirm
    }
    params = RPS::UserSignUp.run(params)
    if params[:error] == :user_already_exist
      puts "*user exist already exist*"
      run
    end
    if params[:error] == :mismatch_passwords
      puts "*passwords don't match*"
      run
    end
    if params[:success?]
      puts "*success!*"
    end
    run
  end

def run
  puts "SIGN IN or SIGN UP"
  input = gets.chomp
  if input.downcase == "sign in"
    sign_in_test
  elsif input.downcase == "sign up"
    sign_up_test
  else
    puts "*invalid input*"
    run
  end
end

run
