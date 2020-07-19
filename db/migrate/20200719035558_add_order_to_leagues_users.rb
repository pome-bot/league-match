class AddOrderToLeaguesUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :leagues_users, :order, :integer
    add_index :leagues_users, :order
  end
end
