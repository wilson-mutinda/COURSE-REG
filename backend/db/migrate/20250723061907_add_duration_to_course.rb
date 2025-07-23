class AddDurationToCourse < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :duration, :string
  end
end
