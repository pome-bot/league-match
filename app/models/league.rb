class League < ApplicationRecord

  belongs_to :group
  has_many :leagues_users
  has_many :users, through: :leagues_users
  has_many :games

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
    i = 0
    games.order(order: "ASC").each do |game|
      game_user2_names[i] = User.find_by(id: game.user2_id).name
      i += 1
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

end
