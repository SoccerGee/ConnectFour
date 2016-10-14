require "active_model"
require "application_helper"

conn = ActiveRecord::Base.connection()

# default cpu user
Player.create email: "connectfour@salesloft.com", pin: "1337", is_cpu: true
