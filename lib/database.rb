require 'pg'

module RPS
  class ORM
    def initialize 
      @db = PG..connect(host: 'localhost', dbname: 'RPS_db')
    end
    def create_user(user_name)
      command = <<-SQL
        INSERT INTO users( user_name )
        VALUES ( '#{name}' )
        returning *;
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
    end

    def update_user(user_name, id)
      @db.exec("UPDATE users SET name = '#{user_name}' WHERE id = #{id};")
    end
  end

  def self.orm
    @__db__ ||= ORM.new
  end
end