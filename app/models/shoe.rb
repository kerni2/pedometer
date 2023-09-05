class Shoe < ApplicationRecord
  has_many :activities
  belongs_to :user

  validates :name, presence: true
  validates :allowed_distance_in_miles, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }

  after_save :notify_user, if: :shoe_mileage_reached?

  scope :alphabetized, -> { order(name: :asc) }
  scope :ordered, -> { order(retired: :asc) }
  scope :available, -> { where(retired: false) }

  def name_with_miles
    "#{self.name} (#{self.distance_in_miles} miles)"
  end

  private

  def notify_user
    NotifyUserMailer.shoe_mileage_reached(self).deliver_now
    self.notified = true
  end

  def shoe_mileage_reached?
    !self.notified? && !self.allowed_distance_in_miles.nil? && self.distance_in_miles >= self.allowed_distance_in_miles
  end
end
