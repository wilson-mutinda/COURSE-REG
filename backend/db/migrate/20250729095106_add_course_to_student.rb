class AddCourseToStudent < ActiveRecord::Migration[7.1]
  def change
    add_reference :students, :course, foreign_key: true
  end
end
