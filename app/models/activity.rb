class Activity < ApplicationRecord
  belongs_to :user

  enum category: [:run, :long_run, :workout, :race, :other]
  enum difficulty: [:easy, :moderate, :hard]
  enum unit: [:miles, :kilometers, :meters, :yards]

  before_save :calculate_pace

  validates :date, presence: true
  validates :distance, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }, presence: true
  validates :unit, presence: true

  private
    def calculate_pace
      if self.unit.present? && self.distance.present? && self.duration.present?
        case self.unit
        when "miles"
          self.calculated_pace = self.duration / self.distance
        when "kilometers"
          self.calculated_pace = self.duration / ( self.distance * 0.6213712 )
        when "meters"
          self.calculated_pace = self.duration / ( self.distance * 0.0006213711985 )
        when "yards"
          self.calculated_pace = self.duration / ( self.distance * 0.0005681818239083977 )
        end
      end
    end
end
