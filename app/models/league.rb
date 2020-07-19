class League < ApplicationRecord

  belongs_to :group
  has_many :leagues_users
  has_many :users, through: :leagues_users
  has_many :games

end
