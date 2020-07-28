class AddWinPointColumnsToLeagues < ActiveRecord::Migration[6.0]
  def change

    remove_column :leagues, :win_point, :integer
    remove_column :leagues, :lose_point, :integer
    remove_column :leagues, :even_point, :integer

    add_column :leagues, :win_point, :integer, default: 3, null: false
    add_column :leagues, :lose_point, :integer, default: 0, null: false
    add_column :leagues, :even_point, :integer, default: 1, null: false

  end
end
