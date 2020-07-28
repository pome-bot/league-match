class AddColumnsToLeaguesUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :leagues_users, :won, :integer, default: 0
    add_column :leagues_users, :lost, :integer, default: 0
    add_column :leagues_users, :even, :integer, default: 0
    add_column :leagues_users, :point, :integer, default: 0
    add_column :leagues_users, :rank, :integer, default: 0

    add_index :games, :user2_id

    add_column :leagues, :win_point, :integer, default: 3
    add_column :leagues, :lose_point, :integer, default: 0
    add_column :leagues, :even_point, :integer, default: 1

  end
end
