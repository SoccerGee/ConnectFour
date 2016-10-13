require "active_model"
require "application_helper"

conn = ActiveRecord::Base.connection()

# batch insert of player_types through sql b/c there is no model for player_types.
user_type = conn.execute "insert into player_types (name) values ('cpu'),('user') returning id"
cpu_type_id = user_type[0]["id"]

# default cpu user
Player.create email: "connectfour@salesloft.com", pin: "1337", type_id: cpu_type_id
