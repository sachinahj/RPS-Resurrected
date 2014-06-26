require 'digest'

module RPS
  class User
    attr_reader :id, :user_name

    def initialize(id=nil, user_name, password_digest=nil)
      @id = id
      @user_name = user_name
      @password_digest = password_digest
    end

    def create!
      id_from_db = RPS.orm.create_user(@user_name)
      @id = id_from_db
      self
    end

    def save!
      id_from_db = RPS.orm.update_user(@user_name, @id)
    end

    def update_password(password)
      # TODO: Hash incoming password and save as password digest
      @password_digest =  Digest::SHA1.hexdigest(password)
    end

    def has_password?(password)
      # TODO: Hash incoming password and compare against own password_digest
      @password_digest ==  Digest::SHA1.hexdigest(password)
    end
  end
end