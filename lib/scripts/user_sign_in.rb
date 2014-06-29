module RPS
  class UserSignIn
    def self.run(params)
      # params = {:username, :password}
      user = RPS::User.get_user_object_by_username(params[:username])

      if  user == nil
        return {
          :success? => false,
          :error => :no_user_exist,
          :session_id => nil,
          :user => nil
        }
      elsif user.has_password?(params[:password]) == false 
        return {
          :success? => false,
          :error => :invalid_password,
          :session_id => nil,
          :user => nil
        }
      elsif user.has_password?(params[:password]) == true
        session_id = user.create_session
        user = user.save!
        return {
          :success? => true,
          :error => :none,
          :session_id => session_id,
          :user => user
        }
      else
        return {
          :success? => false,
          :error => :no_idea,
          :session_id => nil,
          :user => nil
        }
      end
    end
  end
end




















