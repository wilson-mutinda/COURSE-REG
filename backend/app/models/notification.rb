class Notification < ApplicationRecord
  belongs_to :user

  validates :action, :message, presence: true
end
