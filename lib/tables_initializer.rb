require 'pg'

db = PG.connect(host: 'localhost', dbname: 'RPS_db')

command = <<-SQL
CREATE TABLE users(
   id SERIAL,
   user_name text,
   password text,
   wins integer,
   losses integer,
   PRIMARY KEY( id )
);

CREATE TABLE match_records(
   id SERIAL,
   user1_id integer,
   user2_id integer,
   history_hash text,
   game_count integer,
   move1_made boolean,
   move2_made boolean,
   winner integer,
   PRIMARY KEY( id )
);
SQL
result = db.exec(command)
p result.values