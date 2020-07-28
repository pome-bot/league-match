class Message < ApplicationRecord

  belongs_to :league
  belongs_to :user

  validates :text, presence: true, length: {minimum: 1, maximum: 200}

end
