require 'digest'

module RPS
  class User
    attr_accessor :user_name, 
      :id,
      :password_digest,
      :overall_wins,
      :overall_losses
    def initialize(
      user_name,
      id=nil,
      password_digest=nil,
      overall_wins=0,
      overall_losses=0
    )
      @id = id
      @user_name = user_name
      @password_digest = password_digest
      @overall_wins = overall_wins
      @overall_losses = overall_losses
    end
    def create!
      id_from_db = RPS.orm.create_user(@user_name)
      @id = id_from_db
      self
    end
    def save!
      id_from_db = RPS.orm.update_user(
        @user_name,
        @id,
        @password_digest,
        @overall_wins,
        @overall_losses
      )
      self
    end
    def update_password(password)
      @password_digest =  Digest::SHA1.hexdigest(password)
    end
    def has_password?(password)
      @password_digest ==  Digest::SHA1.hexdigest(password)
    end

    def self.get_user_object_by_user_name(user_name)
      params = RPS.orm.get_user_info_by_user_name(user_name)
      user = RPS::User.new(
        params.first["user_name"],
        params.first["id"].to_i,
        params.first["password_digest"],
        params.first["wins"].to_i,
        params.first["losses"].to_i
      )
      return user
    end

    def self.get_user_object_by_user_id(user_id)
      params = RPS.orm.get_user_info_by_user_id(user_id)
      user = RPS::User.new(
        params.first["user_name"],
        params.first["id"].to_i,
        params.first["password_digest"],
        params.first["wins"].to_i,
        params.first["losses"].to_i
      )
      return user
    end
  end
end






