require 'digest'

module RPS
  class User
    attr_reader :id, :username

    def initialize(id, username, password_digest=nil)
      @id = id
      @username = username
      @password_digest = password_digest
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