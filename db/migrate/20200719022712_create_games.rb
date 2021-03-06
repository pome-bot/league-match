class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|

      t.references :league, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :user2_id, null: false
      t.integer :user_score
      t.integer :user2_score
      t.integer :order, null: false

      t.timestamps
    end

    add_index :games, [:league_id, :user_id, :user2_id], unique: true

  end
end


