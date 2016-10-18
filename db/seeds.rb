require "active_model"
require "application_helper"

conn = ActiveRecord::Base.connection()

# default cpu user
User.create email: ENV["CPU_PLAYER_EMAIL"], password: "1337gamez", is_cpu: true
