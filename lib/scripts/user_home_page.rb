module RPS
  class UserHomePage
    def self.run(params)
      # params = {:success?, :error, :session_id, :user}
      user = params[:user]
      puts "---#{user.username}'s Home Page---"
      puts "user id: #{user.id}"
      puts "password digest: #{user.password_digest}"
      puts "wins: #{user.wins}"
      puts "losses: #{user.losses}"
      puts "session_id: #{user.session_id}"
      if user.pending_match != nil
        print "You have a match pending. CONTINUE"
        gets.chomp
        RPS::ContinueMatch.run(user)
      else
        print "starting a NEW GAME"
        gets.chomp
        RPS::NewMatch.run(user)
      end
    end
  end
end
