class League < ApplicationRecord

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :win_point, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: -10000, less_than_or_equal_to: 10000}
  validates :lose_point, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: -10000, less_than_or_equal_to: 10000}
  validates :even_point, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: -10000, less_than_or_equal_to: 10000}
  validates :order_flag, presence: true, inclusion: {in: [0, 1]}

  belongs_to :group
  has_many :leagues_users
  has_many :users, through: :leagues_users, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :messages, dependent: :destroy

  def compare_tie_ranker_with_dif
    lusers = leagues_users

    lusers.length.times do |i|
      if lusers.where(rank: i+1).length >= 2
        rank_tie = i+1
        update_tie_rankers_with_dif(rank_tie)
      end
    end
  end

  def compare_tie_ranker_with_match
    lusers = leagues_users

    lusers.length.times do |i|
      if lusers.where(rank: i+1).length >= 2
        rank_tie = i+1
        update_tie_rankers_with_match(rank_tie)
      end
    end
  end

  def update_leagues_users_table_rank_temp
    lusers = leagues_users
    points = []
    lusers.each do |luser|
      points << luser.point
    end
    max = points.max
    min = points.min
    rank = Array.new(max+2, 0)
    rank[max+1] = 1
    
    lusers.count.times do |i|
      rank[points[i]] += 1 
    end
    
    i = max
    (max+1 - min).times do
      rank[i] += rank[i+1]
      i -= 1
    end
    
    lusers.each_with_index do |luser, i|
      luser.update(rank: rank[points[i]+1])
    end
  end

  def get_won_count(user_id)
    gameAs = games.where(user_id: user_id)
    gameBs = games.where(user2_id: user_id)
    i = 0
    gameAs.each do |game|
      if game.user_score.present?
        if game.user_score > game.user2_score
          i += 1
        end
      end
    end
    gameBs.each do |game|
      if game.user_score.present?
        if game.user_score < game.user2_score
          i += 1
        end
      end
    end
    return i
  end

  def get_lost_count(user_id)
    gameAs = games.where(user_id: user_id)
    gameBs = games.where(user2_id: user_id)
    i = 0
    gameAs.each do |game|
      if game.user_score.present?
        if game.user_score < game.user2_score
          i += 1
        end
      end
    end
    gameBs.each do |game|
      if game.user_score.present?
        if game.user_score > game.user2_score
          i += 1
        end
      end
    end
    return i
  end

  def get_even_count(user_id)
    gameAs = games.where(user_id: user_id)
    gameBs = games.where(user2_id: user_id)
    i = 0
    gameAs.each do |game|
      if game.user_score.present?
        if game.user_score == game.user2_score
          i += 1
        end
      end
    end
    gameBs.each do |game|
      if game.user_score.present?
        if game.user_score == game.user2_score
          i += 1
        end
      end
    end
    return i
  end

  def get_difference(user_id)
    gameAs = games.where(user_id: user_id)
    gameBs = games.where(user2_id: user_id)
    i = 0
    gameAs.each do |game|
      if game.user_score.present?
        i += game.user_score
        i -= game.user2_score
      end
    end
    gameBs.each do |game|
      if game.user_score.present?
        i -= game.user_score
        i += game.user2_score
      end
    end
    return i
  end

  def create_games(group)
    user_num = users.length
    place_user = Array.new(user_num)

    if group.leagues.length == 1
      random_array = (0..user_num-1).to_a
    else
      random_array = (0..user_num-1).to_a.sort_by{rand}
    end

    i = 0
    users.order(name: "ASC").each do |user|
      place_user[random_array[i]] = user
      i += 1
    end

    if user_num % 2 == 0 # even
      game_homes_temp, game_visitors_temp = even_gameABs(user_num)
      order = 0
      (user_num-1).times do |i|
        (user_num/2).times do |j|
          Game.create(league_id: id, 
                      user_id: place_user[game_homes_temp[i][j]-1].id, 
                      user2_id: place_user[game_visitors_temp[i][j]-1].id, 
                      order: order)
          order += 1
        end
        leagues_user = leagues_users.find_by(user_id: place_user[i].id)
        leagues_user.update(order: i)
      end
      leagues_user = leagues_users.find_by(user_id: place_user[user_num-1].id)
      leagues_user.update(order: user_num-1)
    else  # user_num % 2 == 1 # odd
      game_homes_temp, game_visitors_temp = odd_gameABs(user_num)
      order = 0
      user_num.times do |i|
        ( (user_num-1)/2 ).times do |j|
          Game.create(league_id: id, 
                      user_id: place_user[game_homes_temp[i][j]-1].id, 
                      user2_id: place_user[game_visitors_temp[i][j]-1].id, 
                      order: order)
          order += 1
        end
        leagues_user = leagues_users.find_by(user_id: place_user[i].id)
        leagues_user.update(order: i)
      end
    end
  end

  def get_game_scores(user_id, user2_id)
    gameA = games.find_by(user_id: user_id, user2_id: user2_id)
    gameB = games.find_by(user_id: user2_id, user2_id: user_id)

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

  def get_name_array
    name_array = Array.new(users.length) 
    i = 0
    users.order("name ASC").each do |user|
      name_array[i] = user.name
      i += 1 
    end
    return name_array
  end

  def get_user2_names
    game_user2_names = Array.new(games.length)
    games.order(order: "ASC").each_with_index do |game, i|
      if User.find_by(id: game.user2_id).present?
        game_user2_names[i] = User.find_by(id: game.user2_id).name
      else
        game_user2_names[i] = ""
      end
    end
    return game_user2_names
  end

  def get_game_nones
    game_nones = Array.new(users.length)
    leagues_users.each do |luser|
      game_nones[luser.order] = luser.user.name
    end
    game_nones.unshift game_nones[users.length-1]
    game_nones.pop
    return game_nones
  end

  private

  def even_gameABs(user_num)
    place = Array.new(user_num)
    gameA = Array.new(user_num-1) { Array.new(user_num/2) }
    gameB = Array.new(user_num-1) { Array.new(user_num/2) }
  
    user_num.times do |i|
      place[i] = i+1
    end
  
    (user_num-1).times do |i|
      (user_num/2).times do |j|
        if (j%2 == 1) || (i%2 == 1 && j==0)
          gameA[i][j] = place[user_num-(j+1)]
          gameB[i][j] = place[j]
        else
          gameA[i][j] = place[j]
          gameB[i][j] = place[user_num-(j+1)]
        end
      end
      place = shift_place_even(place,user_num)
    end
  
    return gameA, gameB
  end
  
  def odd_gameABs(user_num)
    place = Array.new(user_num)
    gameA = Array.new(user_num) { Array.new( (user_num-1)/2 ) }
    gameB = Array.new(user_num) { Array.new( (user_num-1)/2 ) }
  
    user_num.times do |i|
      place[i] = i+1
    end
  
    user_num.times do |i|
      ( (user_num-1)/2 ).times do |j|
        if j%2 == 1
          gameA[i][j] = place[ user_num-(j+2)]
          gameB[i][j] = place[j]
        else          
          gameA[i][j] = place[j]
          gameB[i][j] = place[ user_num-(j+2)]
        end
      end
      place = shift_place_odd(place, user_num)
    end
  
    return gameA, gameB
  end
  
  def shift_place_even(place, user_num)
    place.unshift 1
    place[1] = place[user_num]
    place.pop
    return place
  end
  
  def shift_place_odd(place, user_num)
    place << place[0]
    place.shift
    return place
  end

  def update_tie_rankers_with_dif(rank_tie)
    lusers = leagues_users.where(rank: rank_tie)
    difs = []
    lusers.each do |luser|
      difs << luser.difference
    end
    max = difs.max
    min = difs.min

    if min < 0
      difs = []
      lusers.each do |luser|
        difs << luser.difference - min
      end
      max -= min
      min = 0
    end

    rank = Array.new(max+2, 0)
    rank[max+1] = 1

    lusers.count.times do |i|
      rank[difs[i]] += 1 
    end
    
    i = max
    (max+1 - min).times do
      rank[i] += rank[i+1]
      i -= 1
    end
    
    lusers.each_with_index do |luser, i|
      luser.update(rank: rank_tie + rank[difs[i]+1] - 1)
    end
  end

  def update_tie_rankers_with_match(rank_tie)
    lusers = leagues_users.where(rank: rank_tie)

    if lusers.count == 2
      luser1 = lusers[0]
      luser2 = lusers[1]

      gameA = games.find_by(user_id: luser1.user_id, user2_id: luser2.user_id)
      gameB = games.find_by(user_id: luser2.user_id, user2_id: luser1.user_id)

      if gameA.present?
        if gameA.user_score.present?
          if gameA.user_score > gameA.user2_score
            luser2.update(rank: rank_tie + 1)
          elsif gameA.user_score < gameA.user2_score
            luser1.update(rank: rank_tie + 1)
          end
        end
      end
      if gameB.present?
        if gameB.user_score.present?
          if gameB.user_score > gameB.user2_score
            luser1.update(rank: rank_tie + 1)
          elsif gameB.user_score < gameB.user2_score
            luser2.update(rank: rank_tie + 1)
          end
        end
      end
    end
  end

end
