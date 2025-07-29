class Course < ApplicationRecord
  belongs_to :user
  has_many :students

  # validations
  validates :name, presence: true, uniqueness: true, if: -> { new_record? || name.present? }
  validates :category, presence: true, if: -> { new_record? || category.present? }
  validates :duration, presence: true, if: -> { new_record? || duration.present? }
end
