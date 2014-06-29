module RPS
  class ContinueMatch
    def self.run(match, user)
      p "match --> #{match.inspect}"
      puts "---New Match---"
      puts "Player 1: #{match.user1.username}"
      puts "Player 2: #{match.user2.username}"

      if user.id == match.user1.id
        user_index = 0 
        opponent_index = 1
      end
      if user.id == match.user2.id
        user_index = 1
        opponent_index = 0
      end

      puts "user_index --> #{user_index}"
      puts "opponent_index --> #{opponent_index}"

      while(true)
        p "match.moves_made?[user_index] --> #{match.moves_made?[user_index]}"
        if match.moves_made?[user_index] == false
          puts "Your Move!"
          print "r, p, s?: "
          move = gets.chomp
          if move.downcase == "r"
            match.user1_move = "rock" if user_index == 0
            match.user2_move = "rock" if user_index == 1
            break
          elsif move.downcase == "p"
            match.user1_move = "paper" if user_index == 0
            match.user2_move = "paper" if user_index == 1
            break
          elsif move.downcase == "s"
            match.user1_move = "scissors" if user_index == 0
            match.user2_move = "scissors" if user_index == 1
            break
          end
        else
          break
        end
      end
      match.save!

      if match.moves_made?[opponent_index] == false
        puts "Waiting on opponent to make move"
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
        puts "#{match.user1.username} wins: #{match.user1_game_wins}"
        puts "#{match.user2.username} wins: #{match.user2_game_wins}"
        puts "Continue to next game..."
      end
    end
  end
end
