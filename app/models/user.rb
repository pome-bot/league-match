class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  # validates :name, presence: true, uniqueness: {case_sensitive: true}

  has_many :groups_users
  has_many :groups, through: :groups_users, dependent: :destroy
  has_many :leagues_users
  has_many :leagues, through: :leagues_users, dependent: :destroy
  has_many :games, dependent: :nullify

end
