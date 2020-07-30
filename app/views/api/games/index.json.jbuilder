json.update_flag @update_flag
json.data_for_table do
  json.users_for_table do
    json.array! @users_for_table, :name
  end
  json.table_rows do
    json.array! @table_rows
  end
end
json.data_for_order do
  json.games_for_order do
    json.array! @games_for_order
  end
end

