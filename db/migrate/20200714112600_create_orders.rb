class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|

      t.references :league, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :order, null: false

      t.timestamps
    end

    add_index :orders, [:league_id, :user_id], unique: true

  end
end

