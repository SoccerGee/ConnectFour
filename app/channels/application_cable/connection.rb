module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Devise::Controllers::Helpers

    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      if user_signed_in?
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
