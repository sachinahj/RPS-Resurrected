module RPS
  class UserSignUp
    def self.run(params)
      # params = {:username, :password, :password_confirm}
      user = RPS::User.get_user_object_by_username(params[:username])

      if  user != nil
        return {
          :success? => false,
          :error => :user_already_exist,
          :session_id => nil,
          :user => nil
        }
      elsif params[:password] != params[:password_confirm]
        return {
          :success? => false,
          :error => :mismatch_passwords,
          :session_id => nil,
          :user => nil
        }
      else
        user = RPS::User.new(params[:username])
        user.create!
        user.update_password(params[:password])
        user.save!
        session_id = user.create_session
        user = user.save!

        return {
          :success? => true,
          :error => :none,
          :session_id => session_id,
          :user => user
        }
      end
    end
  end
end
