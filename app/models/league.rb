class League < ApplicationRecord

  belongs_to :group
  has_many :leagues_users
  has_many :users, through: :leagues_users
  has_many :games

  def get_game_scores(user_id, user2_id)
    gameA = games.where(user_id: user_id).find_by(user2_id: user2_id)
    gameB = games.where(user_id: user2_id).find_by(user2_id: user_id)
    if gameA.present?
      if gameA.user_score
        return "#{gameA.user_score} - #{gameA.user2_score}"
      else
        return nil
      end
    elsif gameB.present?
      if gameB.user_score
        return "#{gameB.user2_score} - #{gameB.user_score}"
      else
        return nil
      end
    else
      return nil
    end
  end

end
