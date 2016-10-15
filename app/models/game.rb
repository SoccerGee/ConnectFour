class Game < ApplicationRecord
  attr_accessor :for_user

  has_one :user, foreign_key: :winner_id
  has_many :moves, dependent: :nullify
  has_and_belongs_to_many :users

  # callbacks must be declared after relations or you will get duplicates in the join table...
  # https://github.com/rails/rails/commit/d1afd987464717f8af1ab0e9a78af6f37b9ce425
  after_create :assign_users

  # get all the wins
  scope :wins, -> { where( winner_id: current_user["id"] ) }

  private

  def assign_users
    binding.pry
    self.users << [self.for_user, User.cpu]
  end
end
