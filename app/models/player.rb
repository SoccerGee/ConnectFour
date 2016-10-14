class Player < ApplicationRecord
  has_one :player_type
  has_many :moves
  has_and_belongs_to_many :games

  validates :email, presence: { message: 'email must be present' }
  validates :email, uniqueness: { message: 'this email is already in use.  Did you forget your pin? Shame on you.' }

  validates :pin,   presence: { message: 'pin must be present' }
  validates :pin,   length: { is: 4, message: 'pin must be 4 characters long.' }

  #This will return the CPU Player Object
  scope :cpu, -> { where( is_cpu: true ) }
end
