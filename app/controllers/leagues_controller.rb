class LeaguesController < ApplicationController

  def new
    @group = Group.find(params[:group_id])
    @league = League.new
    @league.users << @group.users
  end

  def index
    @group = Group.find(params[:group_id])
    @leagues = @group.leagues.includes(:users)
  end

  def create
    @group = Group.find(params[:group_id])
    @league = League.new(league_params)

    if @league.users.length <= 1
      render :new
    elsif @league.save
      place_user = Array.new(@league.users.length)
      random_array = (0..@league.users.length-1).to_a.sort_by{rand}

      i = 0
      @league.users.each do |user|
        place_user[random_array[i]] = user
        i += 1
      end

      if @league.users.length % 2 == 0 # even
        game_homes_temp, game_visitors_temp = even_gameHVs(@league.users.length)
        order = 0
        (@league.users.length-1).times do |i|
          (@league.users.length/2).times do |j|
            Game.create(league_id: @league.id, 
                        user_id: place_user[game_homes_temp[i][j]-1].id, 
                        user2_id: place_user[game_visitors_temp[i][j]-1].id, 
                        order: order)
            order += 1
          end
          leagues_user = @league.leagues_users.find_by(user_id: place_user[i].id)
          leagues_user.update(order: i)
          order += 1
        end
        leagues_user = @league.leagues_users.find_by(user_id: place_user[@league.users.length-1].id)
        leagues_user.update(order: @league.users.length-1)
      else  # @league.users.length % 2 == 1 # odd
        game_homes_temp, game_visitors_temp = odd_gameHVs(@league.users.length)
        order = 0
        @league.users.length.times do |i|
          ( (@league.users.length-1)/2 ).times do |j|
            Game.create(league_id: @league.id, 
                        user_id: place_user[game_homes_temp[i][j]-1].id, 
                        user2_id: place_user[game_visitors_temp[i][j]-1].id, 
                        order: order)
            order += 1
          end
          leagues_user = @league.leagues_users.find_by(user_id: place_user[i].id)
          leagues_user.update(order: i)
          order += 1
        end
      end
      # redirect_to group_league_path(@league.group_id, @league.id)
      redirect_to root_path
    else # @league.save => false
      render :new
    end
  end

  def show
    @game = Game.new
    @group = Group.find(params[:group_id])
    @league = League.find(params[:id])

    @users = @league.users.order("created_at ASC")
    @user_num = @users.length
    @games = @league.games


  #   @gameA_results = Array.new(@user_num) { Array.new(@user_num) }
  #   @gameB_results = Array.new(@user_num) { Array.new(@user_num) }

  #   place_id = Array.new(@user_num)
  #   i = 0
  #   @users.each do |user|
  #     place_id[i] = user.id
  #     i += 1 
  #   end

  #   @user_num.times do |i|
  #     @user_num.times do |j|
  #       if i == j
  #         @gameA_results[i][j] = nil
  #         @gameB_results[i][j] = nil
  #       elsif @games.where(user_id: place_id[i]).where(user2_id: place_id[j]).length != 0
  #         @gameA_results[i][j] = @results.where(user_id: place_id[i]).where(user2_id: place_id[j])[0].user_score
  #         @gameB_results[i][j] = @results.where(user_id: place_id[i]).where(user2_id: place_id[j])[0].user2_score
  #       elsif @games.where(user_id: place_id[j]).where(user2_id: place_id[i]).length != 0
  #         @gameA_results[i][j] = @results.where(user_id: place_id[j]).where(user2_id: place_id[i])[0].user2_score
  #         @gameB_results[i][j] = @results.where(user_id: place_id[j]).where(user2_id: place_id[i])[0].user_score
  #       else
  #         @gameA_results[i][j] = nil
  #         @gameB_results[i][j] = nil
  #       end
  #     end
  #   end



    @place_name = Array.new(@user_num) 
    i = 0
    @users.each do |user|
      @place_name[i] = user.name
      i += 1 
    end
    
  #   if @user_num <= 1
  #     return false
  #   elsif @user_num % 2 == 0            # even
  #     @game_homes = Array.new(@user_num-1) { Array.new(@user_num/2) }
  #     @game_visitors = Array.new(@user_num-1) { Array.new(@user_num/2) }

  #     game_homes_temp, game_visitors_temp = even_gameHVs(@user_num)

  #     (@user_num-1).times do |i|
  #       (@user_num/2).times do |j|
  #         @game_homes[i][j] = @place_name[game_homes_temp[i][j]-1]
  #         @game_visitors[i][j] = @place_name[game_visitors_temp[i][j]-1]
  #       end
  #     end
  #   else  # @user_num % 2 == 1          # odd
  #     @game_homes = Array.new(@user_num) { Array.new( (@user_num-1)/2 ) }
  #     @game_visitors = Array.new(@user_num) { Array.new( (@user_num-1)/2 ) }
  #     @game_nones = Array.new(@user_num)

  #     game_homes_temp, game_visitors_temp = odd_gameHVs(@user_num)
  #     gameCs_temp = odd_gameNones(@user_num)
  #     @game_nones[0] = @place_name[@user_num-1]

  #     @user_num.times do |i|
  #       ( (@user_num-1)/2 ).times do |j|
  #         @game_homes[i][j] = @place_name[game_homes_temp[i][j]-1]
  #         @game_visitors[i][j] = @place_name[game_visitors_temp[i][j]-1]
  #       end
  #       if i != (@user_num - 1)
  #         @game_nones[i+1] = @place_name[gameCs_temp[i+1]-1]
  #       end
  #     end
  #   end
  end






  private

  def league_params
    params.require(:league).permit(:name, :group_id, user_ids: []).merge(group_id: params[:group_id])
  end

  def even_gameHVs(user_num)
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
  
  def odd_gameHVs(user_num)
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
  
  def odd_gameNones(user_num)
    gameC = Array.new(@user_num)
    gameC[0] =user_num
    (user_num-1).times do |i|
      gameC[i+1] = i+1
    end
    return gameC
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
