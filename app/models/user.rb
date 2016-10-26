class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :moves
  has_and_belongs_to_many :games

  #This will return the CPU Player Object
  scope :cpu, -> { where( is_cpu: true ).first }
end
