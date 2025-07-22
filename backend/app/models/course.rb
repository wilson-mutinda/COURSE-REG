class Course < ApplicationRecord
  belongs_to :user

  # validations
  validates :name, presence: true, uniqueness: true, if: -> { new_record? || name.present? }
end
