json.update_flag @update_flag
json.data_for_order do
  json.user1_name   @user1.id
  json.user2_name   @user2.id
  json.user1_score  @score1
  json.user2_score  @score2
end
json.data_for_table do
  json.users_for_table do
    json.array! @users_for_table, :name
  end
  json.table_rows do
    json.array! @table_rows
  end
end
