class AddCategoryToCourse < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :category, :string
  end
end
