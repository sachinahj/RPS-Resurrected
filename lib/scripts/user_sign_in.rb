module RPS
  class UserSignIn

    def self.run(params)
      p "params from SignIn --> #{params}"
      user = RPS::User.get_user_object_by_username(params[:username])


      if  user == nil
        return {
          :success? => false,
          :error => :no_user_exist,
          :session_id => nil
        }
      elsif user.has_password?(params[:password]) == false 
        return {
          :success? => false,
          :error => :invalid_password,
          :session_id => nil
        }
      elsif user.has_password?(params[:password]) == true
        return {
          :success? => true,
          :error => :none,
          :session_id => Honkr.db.create_session(:user_id => user.id)
        }
      else
        return {
          :success? => false,
          :error => :no_idea,
          :session_id => nil
        }
      end
    end
  end
end


# while(true)
  def sign_in_test
    puts "username:"
    username = gets.chomp
    puts "password:"
    password = gets.chomp
    params = {
      username: username,
      password: password
    }
    p RPS::UserSignIn.run(params)

  end
# end

