require 'pg'

module RPS
  class ORM
    def initialize 
      @db = PG..connect(host: 'localhost', dbname: 'RPS_db')
    end
    def create_user(name)
      command = <<-SQL
        INSERT INTO users( user_name )
        VALUES ( '#{name}' )
        returning *;
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
    end
  end

  def self.orm
    @__db__ ||= ORM.new
  end
end