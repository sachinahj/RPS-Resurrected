require 'pg'

db = PG.connect(host: 'localhost', dbname: 'RPS_db')

command = <<-SQL
CREATE TABLE users(
   id SERIAL,
   user_name text,
   password_digest text,
   wins integer,
   losses integer,
   PRIMARY KEY( id )
);

CREATE TABLE matchs(
   id SERIAL,
   user1_id integer,
   user2_id integer,
   user1_game_wins integer,
   user2_game_wins integer,
   user1_move text,
   user2_move text,
   game_history_hash text,
   last_game_winner integer,
   match_winner integer,
   PRIMARY KEY( id )
);
SQL
result = db.exec(command)
p result.values