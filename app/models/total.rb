class Total < ApplicationRecord
  belongs_to :user

  scope :ordered, -> { order(starting_on: :desc) }
  
  enum range: [:week]

  validates :starting_on, :range, presence: true
  validates :user, :range, uniqueness: { scope: [:starting_on, :range] }
end
