class AddOrderFlagColumnToLeagues < ActiveRecord::Migration[6.0]
  def change
    add_column :leagues, :order_flag, :integer, default: 0, null: false
  end
end
