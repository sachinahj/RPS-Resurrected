require 'spec_helper'
require 'pry-byebug'
require 'pg'

describe RPS::User do
  describe "initialize" do
    it "intializes a User object with a name" do
      user = RPS::User.new("sachinahj")
      expect(user.username).to eq("sachinahj")
    end
  end

  describe "create!" do
    it "assigns id to User object" do
      user = RPS::User.new("pseudo_user")
      return_value = user.create!
      expect(user.id).not_to eq(nil)
      expect(return_value).to eq(user)
      
      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'pseudo_user'])
    end
    it "returns nil if username already exists" do
      user = RPS::User.new("sachinahj")
      user.create!
      user2 = RPS::User.new("sachinahj")
      return_value = user2.create!
      expect(user2.id).to eq(nil)
      expect(return_value).to eq(nil)
      
      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachinahj'])
    end
  end

  describe "update_password and has_password?" do
    it  "updates the password and checks to see if the correct password is given" do
      user = RPS::User.new("sachinahj", 1111)
      user.update_password("igohardinthepaint")
      expect(user.has_password?("isometimesgohardinthepaint")).to eq(false)
      expect(user.has_password?("igohardinthepaint")).to eq(true)
    end
  end

  describe ".get_user_object_by_username" do
    before do
      @user = RPS::User.new("sachinahj")
      @user.create!
      @user_id = @user.id
    end
    it "returns User object with specified username" do
      user = RPS::User.get_user_object_by_username("sachinahj")
      expect(user.id).to eq(@user_id)
      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachinahj'])
    end
    it "returns nil if specified username doesn't exist" do
      user = RPS::User.get_user_object_by_username("la_di_da")
      expect(user).to eq(nil)
      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachinahj'])
    end
    
  end


  describe ".get_user_object_by_id" do
    before do
      @user = RPS::User.new("sachinahj")
      @user.create!
      @user_id = @user.id
    end
    it "returns User object with specified id" do
      user_with_id = RPS::User.get_user_object_by_user_id(@user_id)
      expect(user_with_id.id).to eq(@user_id)
      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachinahj'])
    end
    it "returns nil if specified user id doesn't exist" do
      user = RPS::User.get_user_object_by_user_id(-1)
      expect(user).to eq(nil)
      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachinahj'])
    end
    
  end

  describe "save!" do
    it "updates User object to database" do
      user = RPS::User.new("sachinahj")
      user = user.create!
      user_id = user.id
      user.wins += 1
      user.losses += 3
      user.update_password("password")
      return_value = user.save!

      updated_user = RPS::User.get_user_object_by_username("sachinahj")
      expect(updated_user.id).to eq(user_id)
      expect(updated_user.wins).to eq(1)
      expect(updated_user.losses).to eq(3)
      expect(updated_user.has_password?("password")).to eq(true)
      expect(return_value).to eq(user)

      db = PG.connect(host: 'localhost', dbname: 'RPS_db')
      db.exec(%Q[DELETE FROM users WHERE username = 'sachinahj'])
    end
  end
end
