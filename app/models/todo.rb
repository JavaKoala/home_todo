class Todo < ApplicationRecord
  attr_accessor :send_to_calendar

  belongs_to :list
  validates :description, presence: true
  validates :due, presence: true

  scope :list_order, ->(list) { where(list: list).order(:done, :due) }
end
