json.user_num @league.users.length
json.array_for_order do
  json.array! @games do |game|
    json.user_name   game.user.name
    json.user_score  game.user_score
    json.user2_score game.user2_score
  end
end
json.array_for_order_user2_names do
  json.array! do
    
  end
end
json.array_for_order_game_nones do
  json.array! do
    
  end
end

