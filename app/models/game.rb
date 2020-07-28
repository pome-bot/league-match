class Game < ApplicationRecord

  validates :user_id, presence: true
  validates :user2_id, presence: true
  # validates :user_score, numericality: {only_integer: true, greater_than_or_equal_to: -10000, less_than_or_equal_to: 10000}
  # validates :user2_score, numericality: {only_integer: true, greater_than_or_equal_to: -10000, less_than_or_equal_to: 10000}

  belongs_to :user
  belongs_to :league

      
end
