class Game < ApplicationRecord

  validates :user_id, presence: true
  validates :user2_id, presence: true

  belongs_to :user
  belongs_to :league

      
end
