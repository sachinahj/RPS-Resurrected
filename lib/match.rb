module RPS
  class Match
    def self.run(user1_id, user2_id)
      #check to see if match between 2 users exists
        #if not start new match
        #if yes return history hash of match from database 
      #check to see if move of user has been made from database
        #if not ask for move
        #if yes, continue
      #check to see if both moves have been made from database
        #if not ask user to wait
        #if yes return hash of result and update history hash in database
      #

    end

    def play_match
      game = RPS::Game.new
      while @win1 < 3 || @win2 < 3
        user1_throw = gets.chomp
        user2_throw = gets.chomp
        result = game.play(user1_throw, user2_throw)

      end
    end

    def history_decoder
    end
    def check_for_win
      if 
    end


    
  end

  class Game
    def initialize
      @win1 = 0
      @win2 = 0
      @game_history = ""
      @beats = {
        "rock" => "scissors",
        "paper" => "rock",
        "scissors" => "paper"
      }
    end
    def play(user1_throw, user2_throw)
      user1_throw = user1_throw.downcase
      user2_throw = user2_throw.downcase
      if user1_throw == user2_throw
        add_to_game_history("12T")
        return "tie"
      elsif @beats[user1_throw] == user2_throw
        @win1 +=1
        add_to_game_history("1#{user1_throw.slice(0)}2#{user2_throw.slice(0)}")
        return "user1_win"
      else
        @win2 +=1
        add_to_game_history("1#{user1_throw.slice(0)}2#{user2_throw.slice(0)}")
        return "user2_win"
      end
    end
    def add_to_game_history(game_outcome)
      @game_history << game_outcome
    end


  end
end


game = RPS::Game.new

p game.play("rock", "scissors")
p game.play("paper", "scissors")
p game.play("scissors", "rock")
p game.play("scissors", "paper")
p game.play("rock", "scissors")
