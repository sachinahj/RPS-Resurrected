module RPS
  class ContinueMatch
    def self.run(user)
      match = RPS::Match.new(user)
      match.create!
      puts "---New Match---"
      match.assign_random_opponent
      match.save!
      puts "Player 1: #{match.user1.username}"
      puts "Player 2: #{match.user2.username}"

      while(true)
        if match.user1_move == nil
          puts "Your Move!"
          print "r, p, s?: "
          move = gets.chomp
          if move.downcase == "r"
            match.user1_move = "rock"
            break
          elsif move.downcase == "s"
            match.user1_move = "paper"
            break
          elsif move.downcase == "p"
            match.user1_move = "scissors"
            break
          end
        end
      end
      match.save!

      if match.moves_made?[1] == false
        puts "Waiting on Player 2 to make move"
      end

      if match.moves_made? == [true, true]
        puts "---Game Results---"
        winner = match.game_winner
        match.add_to_history
        match.clear_moves
        puts "#{match.user1.username}: #{match.user1_move}"
        puts "#{match.user2.username}: #{match.user2_move}"
        if winner == "user1_win"
          puts "#{match.user1.username} won the game!"
        elsif winner == "user2_win"
          puts "#{match.user2.username} won the game!"
        end
        match.save!
        puts "---Match Results---"
        puts "Match History: #{match.game_history_hash}"
        puts "#{match.user1.username} wins: #{match.user1_game_sins}"
        puts "#{match.user2.username} wins: #{match.user2_game_wins}"
        puts "Continue to next game..."
      end
    end
  end
end
