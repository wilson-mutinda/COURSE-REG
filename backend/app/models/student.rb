class Student < ApplicationRecord
  belongs_to :user
  belongs_to :course

  # validations
  validates :first_name, presence: true, if:-> { new_record? || first_name.present? }
  validates :last_name, presence: true, if: -> { new_record? || last_name.present? }

  before_validation :set_student_code

  def self.next_stud_code
    last_student = Student.order(created_at: :desc).first
    if last_student
      last_code = last_student.student_code
      split_code = last_code.split('-')[1].to_i
      next_code = split_code + 1
    else
      next_code = 1
    end
    "S-#{next_code.to_s.rjust(3, '0')}"
  end

  private

  def set_student_code
    if student_code.blank?
      self.student_code = Student.next_stud_code
    end
  end

end