class Group < ApplicationRecord

  validates :name, presence: true, uniqueness: true, length: {minimum: 1, maximum: 100}

  has_many :groups_users
  has_many :users, through: :groups_users, dependent: :destroy
  has_many :leagues, dependent: :destroy

  def is_having_league?
    if leagues.present?
      return true
    else
      return false
    end
  end

end
