require 'pg'

module RPS
  class ORM
    def initialize 
      @db = PG.connect(host: 'localhost', dbname: 'RPS_db')
    end
    def create_user(user_name)
      command = <<-SQL
        INSERT INTO users(user_name)
        VALUES ('#{user_name}')
        returning id;
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
      return params.first["id"]
    end

    def get_user_info_by_user_name(user_name)
      command = <<-SQL
        SELECT * FROM users WHERE user_name = '#{user_name}'
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
      return params
    end

    def get_user_info_by_user_id(user_id)
      command = <<-SQL
        SELECT * FROM users WHERE id = '#{user_id}'
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
      return params
    end

    def update_user(user_name, id)
      @db.exec("UPDATE users SET name = '#{user_name}' WHERE id = #{id};")
    end
  end

  def self.orm
    @__db__ ||= ORM.new
  end
end