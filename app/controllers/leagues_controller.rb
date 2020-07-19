class LeaguesController < ApplicationController

  def new
    @group = Group.find(params[:group_id])
    @league = League.new
    @league.users << @group.users
  end

  def index
    @group = Group.find(params[:group_id])
    @leagues = @group.leagues.order(created_at: "DESC").includes(:users)
  end

  def create
    @group = Group.find(params[:group_id])
    @league = League.new(league_params)
    @user_num = @league.users.length

    if @user_num <= 1
      render :new
    elsif @league.save
      place_user = Array.new(@user_num)
      random_array = (0..@user_num-1).to_a.sort_by{rand}

      i = 0
      @league.users.each do |user|
        place_user[random_array[i]] = user
        i += 1
      end

      if @user_num % 2 == 0 # even
        game_homes_temp, game_visitors_temp = even_gameABs(@user_num)
        order = 0
        (@user_num-1).times do |i|
          (@user_num/2).times do |j|
            Game.create(league_id: @league.id, 
                        user_id: place_user[game_homes_temp[i][j]-1].id, 
                        user2_id: place_user[game_visitors_temp[i][j]-1].id, 
                        order: order)
            order += 1
          end
          leagues_user = @league.leagues_users.find_by(user_id: place_user[i].id)
          leagues_user.update(order: i)
        end
        leagues_user = @league.leagues_users.find_by(user_id: place_user[@user_num-1].id)
        leagues_user.update(order: @user_num-1)
      else  # @user_num % 2 == 1 # odd
        game_homes_temp, game_visitors_temp = odd_gameABs(@user_num)
        order = 0
        @user_num.times do |i|
          ( (@user_num-1)/2 ).times do |j|
            Game.create(league_id: @league.id, 
                        user_id: place_user[game_homes_temp[i][j]-1].id, 
                        user2_id: place_user[game_visitors_temp[i][j]-1].id, 
                        order: order)
            order += 1
          end
          leagues_user = @league.leagues_users.find_by(user_id: place_user[i].id)
          leagues_user.update(order: i)
        end
      end
      redirect_to group_league_path(@league.group_id, @league.id)
    else # @league.save => false
      render :new
    end
  end

  def show
    @game = Game.new
    @group = Group.find(params[:group_id])
    @league = League.find(params[:id])

    @user_num = @league.users.length
    @users = @league.users.order("name ASC")
    @games = @league.games.order(order: "ASC").includes(:user)

    @name_array = Array.new(@user_num) 
    i = 0
    @users.each do |user|
      @name_array[i] = user.name
      i += 1 
    end

    @game_user2_names = Array.new(@games.length)
    i = 0
    @games.each do |game|
      @game_user2_names[i] = User.find_by(id: game.user2_id).name
      i += 1
    end

    @game_nones = Array.new(@user_num)
    @league.leagues_users.each do |luser|
      @game_nones[luser.order] = luser.user.name
    end
    @game_nones.unshift @game_nones[@user_num-1]
    @game_nones.pop



    @test_numnum = League.test(10)






  end

  private

  def league_params
    params.require(:league).permit(:name, :group_id, user_ids: []).merge(group_id: params[:group_id])
  end

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
