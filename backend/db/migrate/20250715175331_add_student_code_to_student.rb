class AddStudentCodeToStudent < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :student_code, :string
  end
end
