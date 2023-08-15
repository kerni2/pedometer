class Total < ApplicationRecord
  belongs_to :user

  enum range: [:week]

  validates :starting_on, :range, presence: true
  validates :user, :range, uniqueness: { scope: [:starting_on, :range] }
end
