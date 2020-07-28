class FixImageColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    # remove_column :users, :imgae, :text

    add_column :users, :image, :text
  end
end
