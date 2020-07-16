class League < ApplicationRecord

  belongs_to :group
  has_many :orders
  has_many :users, through: :orders


end
