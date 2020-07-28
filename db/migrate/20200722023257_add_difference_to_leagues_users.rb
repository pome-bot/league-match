class AddDifferenceToLeaguesUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :leagues_users, :difference, :integer

  end
end
