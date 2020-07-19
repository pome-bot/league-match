class CreateLeaguesUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :leagues_users do |t|

      t.references :league, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :leagues_users, [:league_id, :user_id], unique: true

  end
end


