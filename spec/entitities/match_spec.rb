require 'spec_helper'
require 'pry-byebug'
require 'pg'

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
      expect(@match.last_game_winner_id).to eq(@user1.id)
    end
    it "returns 'user2_win' and stores user2 object in match.last_game_winner instance variable" do
      @match.user1_move = "paper"
      @match.user2_move = "scissors"
      winner = @match.game_winner
      expect(winner).to eq("user2_win")
      expect(@match.last_game_winner_id).to eq(@user2.id)
    end
    it "returns 'tie' and stores nil in match.last_game_winner instance variable" do
      @match.user1_move = "paper"
      @match.user2_move = "paper"
      winner = @match.game_winner
      expect(winner).to eq("tie")
      expect(@match.last_game_winner_id).to eq(0)
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

  describe "create!" do 
    it "assigns id to Match object" do 
      user = RPS::User.new("sachinahj", 111)
      match = RPS::Match.new(user)
      return_value = match.create!
      expect(match.match_id).not_to eq(nil)
      expect(return_value).to eq(match)

      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM matches WHERE id = #{match.match_id}])
    end
  end

  describe "assign_random_opponent" do
    before do 
      @user1 = RPS::User.new("sachina")
      @user1.create!
      @user2 = RPS::User.new("stephenh")
      @user2.create!
      @user3 = RPS::User.new("randomo")
      @user3.create!
    end
    it "assigns a random user2 to the Match object" do
      match = RPS::Match.new(@user1)
      match.create!
      match.assign_random_opponent
      expect(match.user2).not_to eq(@user1)
      expect(match.user2.class).to eq(RPS::User)

      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachina'])
      db.exec(%Q[DELETE FROM users WHERE username = 'stephenh'])
      db.exec(%Q[DELETE FROM users WHERE username = 'randomo'])
      db.exec(%Q[DELETE FROM matches WHERE id = #{match.match_id}])
    end
  end

  describe ".get_match_object_by_match_id" do
    it "returns Match object with specified id" do
      user1 = RPS::User.new("sachina")
      user1.create!
      user2 = RPS::User.new("stephenh")
      user2.create!
      match = RPS::Match.new(user1)
      match.assign_random_opponent
      match.create!

      match_with_id = RPS::Match.get_match_object_by_match_id(match.match_id)
      expect(match_with_id.match_id).to eq(match.match_id)
      expect(match.user1.id).to eq(user1.id)
      expect(match.user2.id).to eq(user2.id)

      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachina'])
      db.exec(%Q[DELETE FROM users WHERE username = 'stephenh'])
      db.exec(%Q[DELETE FROM matches WHERE id = #{match.match_id}])
    end
  end

  describe "save!" do
    it "updates Match object to database" do
      user1 = RPS::User.new("sachina")
      user1.create!
      user2 = RPS::User.new("stephenh")
      user2.create!
      match = RPS::Match.new(user1)
      match.assign_random_opponent
      match.create!

      match.user1_game_wins += 3
      match.user2_game_wins += 1
      match.user1_move = "rock"
      match.user2_move = "scissors"
      match.game_history_hash = "1r*2s*w1:1p*2s*w2:1r*2r*wt:1s*2r*w2:1s*2p*w1:"
      match.last_game_winner_id = user1.id
      return_value = match.save!

      updated_match = RPS::Match.get_match_object_by_match_id(match.match_id)
      expect(updated_match.user1.id).to eq(user1.id)
      expect(updated_match.user2.id).to eq(user2.id)
      expect(updated_match.user1_game_wins).to eq(3)
      expect(updated_match.user2_game_wins).to eq(1)
      expect(updated_match.user1_move).to eq("rock")
      expect(updated_match.user2_move).to eq("scissors")
      expect(updated_match.game_history_hash).to eq("1r*2s*w1:1p*2s*w2:1r*2r*wt:1s*2r*w2:1s*2p*w1:")
      expect(updated_match.last_game_winner_id).to eq(user1.id)
      expect(updated_match.match_id).to eq(match.match_id)
      expect(return_value).to eq(match)

      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachina'])
      db.exec(%Q[DELETE FROM users WHERE username = 'stephenh'])
      db.exec(%Q[DELETE FROM matches WHERE id = #{match.match_id}])
    end
  end
end