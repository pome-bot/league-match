class League < ApplicationRecord

  belongs_to :group
  has_many :leagues_users
  has_many :users, through: :leagues_users
  has_many :games


  def self.test(num)
    return num * 10
  end


  def get_game_scores(user_id, user2_id)
    gameA = games.where(user_id: user_id).find_by(user2_id: user2_id)
    gameB = games.where(user_id: user2_id).find_by(user2_id: user_id)

    if gameA.present?
      if gameA.user_score
        return "#{gameA.user_score} - #{gameA.user2_score}"
      end
    elsif gameB.present?
      if gameB.user_score
        return "#{gameB.user2_score} - #{gameB.user_score}"
      end
    end

    return nil
  end

end
