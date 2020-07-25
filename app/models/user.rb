class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true, length: {minimum: 1, maximum: 100}
  validates :email, presence: true, uniqueness: true, length: {minimum: 1, maximum: 100}
  # validates :name, presence: true, uniqueness: {case_sensitive: true}

  has_many :groups_users
  has_many :groups, through: :groups_users
  has_many :leagues_users
  has_many :leagues, through: :leagues_users
  has_many :games, dependent: :nullify

  mount_uploader :image, ImageUploader

  # instead of deleting, indicate the user requested a delete & timestamp it  
  def soft_delete  
    update_attribute(:deleted_at, Time.current)  
  end  
  
  # ensure user account is active  
  def active_for_authentication?  
    super && !deleted_at  
  end  
  
  # provide a custom message for a deleted account   
  def inactive_message   
    !deleted_at ? super : :deleted_account  
    # xx ? yy : zz
    # if xx then yy else zz end
  end  

  def get_result_won_all
    i = 0
    leagues_users.each do |luser|
      i += luser.won
    end
    return i
  end

  def get_result_lost_all
    i = 0
    leagues_users.each do |luser|
      i += luser.lost
    end
    return i
  end

  def get_result_even_all
    i = 0
    leagues_users.each do |luser|
      i += luser.even
    end
    return i
  end

  def get_result_point_all
    i = 0
    leagues_users.each do |luser|
      i += luser.point
    end
    return i
  end

  def get_result_dif_all
    i = 0
    leagues_users.each do |luser|
      i += luser.difference
    end
    return i
  end

  def get_result_rank_all
    i = 0
    count = 0
    leagues_users.each do |luser|
      if luser.rank != 0
        i += luser.rank
        count += 1
      end
    end
    return sprintf("%.2f", i / count.to_f)
  end

  def any_done_game?
    gameAs = games
    gameBs = Game.where(user2_id: id)

    if gameAs.present?
      gameAs.each do |game|
        if game.user_score.present?
          return true
        end
      end
    end
    if gameBs.present?
      gameBs.each do |game|
        if game.user_score.present?
          return true
        end
      end
    end
    return false
  end

  def get_result_against_user?(auser)
    gameAs = games.where(user2_id: auser.id)
    gameBs = Game.where(user_id: auser.id, user2_id: id)

    if gameAs.present?
      gameAs.each do |game|
        if game.user_score.present?
          return true
        end
      end
    end
    if gameBs.present?
      gameBs.each do |game|
        if game.user_score.present?
          return true
        end
      end
    end
    return false
  end

  def get_result_against_user_won(auser)
    gameAs = games.where(user2_id: auser.id)
    gameBs = Game.where(user_id: auser.id, user2_id: id)
    i = 0
    if gameAs.present?
      gameAs.each do |game|
        if game.user_score.present?
          if game.user_score > game.user2_score
            i += 1
          end
        end
      end
    end
    if gameBs.present?
      gameBs.each do |game|
        if game.user_score.present?
          if game.user_score < game.user2_score
            i += 1
          end
        end
      end
    end      
    return i
  end

  def get_result_against_user_lost(auser)
    gameAs = games.where(user2_id: auser.id)
    gameBs = Game.where(user_id: auser.id, user2_id: id)
    i = 0
    if gameAs.present?
      gameAs.each do |game|
        if game.user_score.present?
          if game.user_score < game.user2_score
            i += 1
          end
        end
      end
    end
    if gameBs.present?
      gameBs.each do |game|
        if game.user_score.present?
          if game.user_score > game.user2_score
            i += 1
          end
        end
      end
    end      
    return i
  end

  def get_result_against_user_even(auser)
    gameAs = games.where(user2_id: auser.id)
    gameBs = Game.where(user_id: auser.id, user2_id: id)
    i = 0
    if gameAs.present?
      gameAs.each do |game|
        if game.user_score.present?
          if game.user_score == game.user2_score
            i += 1
          end
        end
      end
    end
    if gameBs.present?
      gameBs.each do |game|
        if game.user_score.present?
          if game.user_score == game.user2_score
            i += 1
          end
        end
      end
    end      
    return i
  end

  def get_result_against_user_dif(auser)
    gameAs = games.where(user2_id: auser.id)
    gameBs = Game.where(user_id: auser.id, user2_id: id)
    i = 0
    if gameAs.present?
      gameAs.each do |game|
        if game.user_score.present?
          i += game.user_score - game.user2_score
        end
      end
    end
    if gameBs.present?
      gameBs.each do |game|
        if game.user_score.present?
          i += game.user2_score - game.user_score
        end
      end
    end      
    return i
  end

end
