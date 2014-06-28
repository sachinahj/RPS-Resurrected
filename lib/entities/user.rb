require 'digest'

module RPS
  class User
    attr_accessor :username, 
      :id,
      :password_digest,
      :overall_wins,
      :overall_losses,
      :session_id
    def initialize(
      username,
      id=nil,
      password_digest=nil,
      overall_wins=0,
      overall_losses=0,
      session_id = nil
    )
      @id = id
      @username = username
      @password_digest = password_digest
      @overall_wins = overall_wins
      @overall_losses = overall_losses
      @session_id = session_id
    end
    def create!
      id_from_db = RPS.orm.create_user(@username)
      return nil if id_from_db == nil
      @id = id_from_db
      self
    end
    def save!
      id_from_db = RPS.orm.update_user(
        @username,
        @id,
        @password_digest,
        @overall_wins,
        @overall_losses,
        @session_id
      )
      self
    end
    def update_password(password)
      @password_digest =  Digest::SHA1.hexdigest(password)
    end
    def has_password?(password)
      @password_digest ==  Digest::SHA1.hexdigest(password)
    end

    def self.get_user_object_by_username(username)
      params = RPS.orm.get_user_info_by_username(username)
      return nil if params.empty?
      user = RPS::User.new(
        params.first["username"],
        params.first["id"].to_i,
        params.first["password_digest"],
        params.first["wins"].to_i,
        params.first["losses"].to_i,
        params.first["session_id"]
      )
      return user
    end

    def self.get_user_object_by_user_id(user_id)
      params = RPS.orm.get_user_info_by_user_id(user_id)
      return nil if params.empty?
      user = RPS::User.new(
        params.first["username"],
        params.first["id"].to_i,
        params.first["password_digest"],
        params.first["wins"].to_i,
        params.first["losses"].to_i,
        params.first["session_id"]
      )
      return user
    end


  end
end






