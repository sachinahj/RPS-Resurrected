require 'pg'

module RPS
  class ORM
    def initialize 
      @db = PG.connect(host: 'localhost', dbname: 'RPS_db')
    end

    ##----------USER ORM METHODS----------------------
    def create_user(user_name)
      command = <<-SQL
        INSERT INTO users(user_name, password_digest, wins, losses)
        VALUES ('#{user_name}', '#{nil}', 0, 0)
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

    def update_user(user_name, id, password_digest, wins, losses)
      command = <<-SQL
        UPDATE users 
        SET (user_name, password_digest, wins, losses) = 
        ('#{user_name}', '#{password_digest}', '#{wins}', '#{losses}')
        WHERE id = '#{id}'
        returning *;
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
      return params
    end

    def get_all_user_ids
      command = <<-SQL
        SELECT id FROM users;
      SQL
      result = @db.exec(command)
      params = result.values.flatten.map! {|x| x.to_i}
      return params
    end

    ##----------MATCH ORM METHODS----------------------
    def create_match(user1_id)
      command = <<-SQL
        INSERT INTO matches(user1_id, user2_id, user1_game_wins, user2_game_wins, user1_move, user2_move, game_history_hash, last_game_winner_id, match_winner_id)
        VALUES ('#{user1_id}', '#{0}', '#{0}', '#{0}', '#{nil}', '#{nil}', '#{''}', '#{0}', '#{0}')
        returning id;
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
      return params.first["id"]
    end

    def update_match(
      user1_id,
      user2_id,
      user1_game_wins,
      user2_game_wins,
      user1_move,
      user2_move,
      game_history_hash,
      last_game_winner_id,
      match_winner_id,
      match_id
    )
      command = <<-SQL
        UPDATE matches 
        SET (user1_id, user2_id, user1_game_wins, user2_game_wins, user1_move, user2_move, game_history_hash, last_game_winner_id, match_winner_id) = 
        ('#{user1_id}','#{user2_id}','#{user1_game_wins}','#{user2_game_wins}','#{user1_move}','#{user2_move}','#{game_history_hash}','#{last_game_winner_id}','#{match_winner_id}')
        WHERE id = '#{match_id}'
        returning *;
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
      return params
    end

    def get_match_info_by_match_id(match_id)
      command = <<-SQL
        SELECT * FROM matches WHERE id = '#{match_id}'
      SQL
      result = @db.exec(command)
      params = result.map{|x| x}
      return params
    end

  end

  def self.orm
    @__db__ ||= ORM.new
  end
end