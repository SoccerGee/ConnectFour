require "active_model"
require "application_helper"

conn = ActiveRecord::Base.connection()

# default cpu user
User.create email: "grant.tuttle@gmail.com", password: "1337gamez", is_cpu: true
