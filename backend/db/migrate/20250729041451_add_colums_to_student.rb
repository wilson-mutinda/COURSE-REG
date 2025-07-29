class AddColumsToStudent < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :middle_name, :string
    add_column :students, :date_of_birth, :date
    add_column :students, :gender, :string
    add_column :students, :country, :string
  end
end
