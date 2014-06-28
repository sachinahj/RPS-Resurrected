require 'spec_helper'
require 'pry-byebug'

describe RPS::Match do

  before do
    @user1 = RPS::User.new("sachinahj", 1111)
    @user2 = RPS::User.new("stephenh", 1112)
    @match = RPS::Match.new(@user1)
    @match.user2 = @user2
    @match.match_id = 1
  end

  describe "initialize" do
    it "intializes a match with one user" do
      expect(@match.match_id).to eq(1)
      expect(@match.user1).to eq(@user1)
      expect(@match.user2).to eq(@user2)
    end
  end

  describe "moves_made?" do
    it "returns [false, false] when no moves have been made" do
      moves_made = @match.moves_made?
      expect(moves_made).to eq([false, false])
    end
    it "returns [true, false] when only user1 has made a move" do 
      @match.user1_move = "rock"
      moves_made = @match.moves_made?
      expect(moves_made).to eq([true, false])
    end
    it "returns [true, true] when both users have made a move" do
      @match.user1_move = "rock"
      @match.user2_move = "paper"
      moves_made = @match.moves_made?
      expect(moves_made).to eq([true, true])
    end
  end

  describe "game_winner" do 
    it "returns 'user1_win' and stores user1 object in match.last_game_winner instance variable" do
      @match.user1_move = "rock"
      @match.user2_move = "scissors"
      winner = @match.game_winner
      expect(winner).to eq("user1_win")
      expect(@match.last_game_winner).to eq(@user1)
    end
    it "returns 'user2_win' and stores user2 object in match.last_game_winner instance variable" do
      @match.user1_move = "paper"
      @match.user2_move = "scissors"
      winner = @match.game_winner
      expect(winner).to eq("user2_win")
      expect(@match.last_game_winner).to eq(@user2)
    end
    it "returns 'tie' and stores nil in match.last_game_winner instance variable" do
      @match.user1_move = "paper"
      @match.user2_move = "paper"
      winner = @match.game_winner
      expect(winner).to eq("tie")
      expect(@match.last_game_winner).to eq(nil)
    end
  end

  describe "clear_moves" do 
    it "clears each users move" do
      @match.user1_move = "paper"
      @match.user2_move = "paper"
      @match.clear_moves
      expect(@match.user1_move).to eq(nil)
      expect(@match.user2_move).to eq(nil)
    end
  end

  describe "add_to_history" do
    it "correctly creates/adds to the history hash of a played match" do
      @match.clear_moves
      @match.user1_move = "rock"
      @match.user2_move = "scissors"
      @match.game_winner
      @match.add_to_history

      @match.clear_moves
      @match.user1_move = "paper"
      @match.user2_move = "scissors"
      @match.game_winner
      @match.add_to_history

      @match.clear_moves
      @match.user1_move = "rock"
      @match.user2_move = "rock"
      @match.game_winner
      @match.add_to_history

      @match.clear_moves
      @match.user1_move = "scissors"
      @match.user2_move = "rock"
      @match.game_winner
      @match.add_to_history

      @match.clear_moves
      @match.user1_move = "scissors"
      @match.user2_move = "paper"
      @match.game_winner
      @match.add_to_history

      @match.clear_moves
      expect(@match.game_history_hash).to eq("1r*2s*w1:1p*2s*w2:1r*2r*wt:1s*2r*w2:1s*2p*w1:")
    end
  end

  describe "history_decoder" do
    it "correctly decodes the history hash of a played match" do
      @match.game_history_hash = "1r*2s*w1:1p*2s*w2:1r*2r*wt:1s*2r*w2:1s*2p*w1:" 
      history = @match.history_decoder
      expect(history).to eq({
        game1: {user1_move: "r", user2_move: "s", winner: "1"},
        game2: {user1_move: "p", user2_move: "s", winner: "2"},
        game3: {user1_move: "r", user2_move: "r", winner: "t"},
        game4: {user1_move: "s", user2_move: "r", winner: "2"},
        game5: {user1_move: "s", user2_move: "p", winner: "1"}
        })
    end
  end


end