module RPS
  class Match
    attr_accessor :user1,
      :user2,
      :user1_game_wins,
      :user2_game_wins,
      :user1_move,
      :user2_move,
      :game_history_hash,
      :last_game_winner,
      :match_winner,
      :match_id
    def initialize( 
      user1, 
      user2=nil,
      user1_wins=0, 
      user2_wins=0,
      user1_move=nil,
      user2_move=nil,
      game_history_hash="",
      game_winner=nil,
      match_winner=nil,
      id=nil
    )
      @user1 = user1
      @user2 = user2
      @user1_game_wins = user1_wins
      @user2_game_wins = user2_wins
      @user1_move = user1_move
      @user2_move = user2_move
      @game_history_hash = game_history_hash
      @last_game_winner = game_winner
      @match_winner = match_winner
      @match_id = id
    end
    def create!
      id_from_db = RPS.orm.create_match(@user1.id)
      @match_id = id_from_db
    end
    def save!
      last_game_winner_id = nil
      last_game_winner_id = @last_game_winner.id if @last_game_winner.id != nil
      match_winner_id = nil
      match_winner_id = @match_winner.id if @match_winner.id != nil

      RPS.orm.update_match(
        @user1.id,
        @user2.id,
        @user1_game_wins,
        @user2_game_wins,
        @user1_move,
        @user2_move,
        @game_history_hash,
        last_game_winner,
        match_winner_id,
        @match_id,
      )
    end
    def find_random_opponent
      if @user2.nil?
        random_user = RPS.orm._get_random_user()
        if random_user[:id] != @user1.id
          @user2 = RPS::User.new()
        else
          find_random_opponent
        end
      end
    end
    def moves_made?
      user1 = false
      user2 = false
      user1 = true if @user1_move != nil
      user2 = true if @user2_move != nil
      return [user1, user2]
    end
    def game_winner
      beats = {
        "rock" => "scissors",
        "paper" => "rock",
        "scissors" => "paper"
      }
      if user1_move == user2_move
        @last_game_winner = nil
        return "tie"
      elsif beats[user1_move] == user2_move
        @user1_game_wins += 1
        @last_game_winner = @user1
        return "user1_win"
      else
        @user2_game_wins += 1
        @last_game_winner = @user2
        return "user2_win"
      end
    end
    def clear_moves
      @user1_move = nil
      @user2_move = nil
    end
    def history_decoder
      games_hash = []
      games_hash += @game_history_hash.split(":")

      history = Hash.new(){nil}

      games_hash.each_with_index do |game_hash, index|
        game_number = "game" + (index+1).to_s
        history[game_number.to_sym] = {}
        turn_hash = game_hash.split("*")
        history[game_number.to_sym][:user1_move] = turn_hash[0][1].to_s
        history[game_number.to_sym][:user2_move] = turn_hash[1][1].to_s
        history[game_number.to_sym][:winner] = turn_hash[2][1].to_s
      end
      return history
    end  
    def add_to_history
      w = 't'
      w = 1 if @last_game_winner == @user1
      w = 2 if @last_game_winner == @user2
      @game_history_hash << "1#{@user1_move.slice(0)}*2#{@user2_move.slice(0)}*w#{w}:"
    end
  end
end
