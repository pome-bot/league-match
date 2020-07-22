class AddDifference2ToLeaguesUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :leagues_users, :difference, :integer

    add_column :leagues_users, :difference, :integer, default: 0

  end
end
