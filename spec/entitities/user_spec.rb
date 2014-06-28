require 'spec_helper'
require 'pry-byebug'
require 'pg'

describe RPS::User do
  describe "initialize" do
    it "intializes a user with a name" do
      user = RPS::User.new("sachinahj")
      expect(user.username).to eq("sachinahj")
    end
  end

  describe "create!" do
    it "assigns id to User class" do
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
    it  "updates the password and checks to see if the correct password is given" do
      user = RPS::User.new("sachinahj", 1111)
      user.update_password("igohardinthepaint")
      expect(user.has_password?("isometimesgohardinthepaint")).to eq(false)
      expect(user.has_password?("igohardinthepaint")).to eq(true)
    end    
  end


end
