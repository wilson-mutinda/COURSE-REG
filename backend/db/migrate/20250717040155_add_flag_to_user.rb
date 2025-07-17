class AddFlagToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :flag, :string
  end
end
