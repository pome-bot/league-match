class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|

      t.references :league, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :user2_id, null: false
      t.integer :user_score, null: false
      t.integer :user2_score, null: false

      t.timestamps
    end

    add_index :results, [:league_id, :user_id, :user2_id], unique: true

  end
end


