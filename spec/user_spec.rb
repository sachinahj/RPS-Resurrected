require 'spec_helper'
require 'pry-byebug'

describe RPS::User do
  describe "initialize" do
    it "intializes a user with a name and ID" do
      user = RPS::User.new("sachinahj", 1111)
      expect(user.id).to eq(1111)
      expect(user.user_name).to eq("sachinahj")
    end
    it  "updates the password and checks to see if the correct password is given" do
      user = RPS::User.new("sachinahj", 1111)
      user.update_password("igohardinthepaint")
      expect(user.has_password?("isometimesgohardinthepaint")).to eq(false)
      expect(user.has_password?("igohardinthepaint")).to eq(true)
    end    
  end
end