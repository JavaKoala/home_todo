class Todo < ApplicationRecord
  belongs_to :list
  validates :description, presence: true
  validates :due, presence: true
end
