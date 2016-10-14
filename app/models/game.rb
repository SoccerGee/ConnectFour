class Game < ApplicationRecord
  has_one :user, foreign_key: :winner_id

  has_and_belongs_to_many :users
end
