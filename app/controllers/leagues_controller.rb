class LeaguesController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
  end

  def show
    @group = Group.find(params[:group_id])
    @league = League.find(params[:id])

    @users = @league.users
    @team_num = @users.length
    @results = @league.results


    gameA_results = Array.new(@team_num) { Array.new(@team_num) }
    gameB_results = Array.new(@team_num) { Array.new(@team_num) }

    # place_name = Array.new(@team_num)
    # i = 0
    # @users.each do |user|
    #   place_name[i] = user.name
    #   i += 1 
    # end

    @team_num.times do |i|
      @team_num.times do |j|
        if i == j
          gameA_results[i][j] = nil
        else
          # gameA_rsults[i][j] = 
        end
      end
    end






    place_name = Array.new(@team_num)
    i = 0
    @users.each do |user|
      place_name[i] = user.name
      i += 1 
    end
    
    if @team_num <= 1
      return false
    elsif @team_num % 2 == 0            # even
      @gameAs = Array.new(@team_num-1) { Array.new(@team_num/2) }
      @gameBs = Array.new(@team_num-1) { Array.new(@team_num/2) }

      gameAs_temp, gameBs_temp = even_gameAB(@team_num)

      (@team_num-1).times do |i|
        (@team_num/2).times do |j|
          @gameAs[i][j] = place_name[gameAs_temp[i][j]-1]
          @gameBs[i][j] = place_name[gameBs_temp[i][j]-1]
        end
      end
    else  # @team_num % 2 == 1          # odd
      @gameAs = Array.new(@team_num) { Array.new( (@team_num-1)/2 ) }
      @gameBs = Array.new(@team_num) { Array.new( (@team_num-1)/2 ) }
      @gameCs = Array.new(@team_num)

      gameAs_temp, gameBs_temp = odd_gameAB(@team_num)
      gameCs_temp = odd_gameC_br(@team_num)
      @gameCs[0] = place_name[@team_num-1]

      @team_num.times do |i|
        ( (@team_num-1)/2 ).times do |j|
          @gameAs[i][j] = place_name[gameAs_temp[i][j]-1]
          @gameBs[i][j] = place_name[gameBs_temp[i][j]-1]
        end
        if i != (@team_num - 1)
          @gameCs[i+1] = place_name[gameCs_temp[i+1]-1]
        end
      end
    end
  end






  private

  def even_gameAB(team_num)
    place = Array.new(team_num)
    gameA = Array.new(team_num-1) { Array.new(team_num/2) }
    gameB = Array.new(team_num-1) { Array.new(team_num/2) }
  
    team_num.times do |i|
      place[i] = i+1
    end
  
    (team_num-1).times do |i|
      (team_num/2).times do |j|
        if (j%2 == 1) || (i%2 == 1 && j==0)
          gameA[i][j] = place[team_num-(j+1)]
          gameB[i][j] = place[j]
        else
          gameA[i][j] = place[j]
          gameB[i][j] = place[team_num-(j+1)]
        end
      end
      place = shift_place_even(place,team_num)
    end
  
    return gameA, gameB
  end
  
  def odd_gameAB(team_num)
    place = Array.new(team_num)
    gameA = Array.new(team_num) { Array.new( (team_num-1)/2 ) }
    gameB = Array.new(team_num) { Array.new( (team_num-1)/2 ) }
  
    team_num.times do |i|
      place[i] = i+1
    end
  
    team_num.times do |i|
      ( (team_num-1)/2 ).times do |j|
        if j%2 == 1
          gameA[i][j] = place[ team_num-(j+2)]
          gameB[i][j] = place[j]
        else          
          gameA[i][j] = place[j]
          gameB[i][j] = place[ team_num-(j+2)]
        end
      end
      place = shift_place_odd(place, team_num)
    end
  
    return gameA, gameB
  end
  
  def odd_gameC_br(team_num)
    gameC = Array.new(@team_num)
    gameC[0] =team_num
    (team_num-1).times do |i|
      gameC[i+1] = i+1
    end
    return gameC
  end
  
  def shift_place_even(place, team_num)
    place.unshift 1
    place[1] = place[team_num]
    place.pop
    return place
  end
  
  def shift_place_odd(place, team_num)
    place << place[0]
    place.shift
    return place
  end
  
end


