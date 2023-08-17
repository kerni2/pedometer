class Activity < ApplicationRecord
  belongs_to :user

  enum category: [:run, :long_run, :workout, :race, :other]
  enum difficulty: [:easy, :moderate, :hard]
  enum unit: [:miles, :kilometers, :meters, :yards]

  has_rich_text :description

  before_validation :calculate_duration
  before_save :calculate_pace
  after_save :create_total
  after_destroy :subtract_from_total  

  validates :date, presence: true
  validates :distance, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }, presence: true
  validates :unit, presence: true
  validates :hours, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }
  validates :minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59, allow_nil: true }
  validates :seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59, allow_nil: true }

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

  def calculate_duration
    calculated_duration = 0
    
    calculated_duration += self.hours * (60 * 60) if self.hours.present?
    calculated_duration += self.minutes * 60 if self.minutes.present?
    calculated_duration += self.seconds if self.seconds.present?
    
    self.duration = calculated_duration unless calculated_duration == 0
  end

  def create_total
    week = self.date.to_date.cweek
    year = self.date.to_date.cwyear
    starting_on = Date.commercial(year, week)

    original_duration = self.duration

    case self.unit
    when "miles"
      converted_distance = self.distance
    when "kilometers"
      converted_distance = self.distance * 0.6213712
    when "meters"
      converted_distance = self.distance * 0.0006213711985
    when "yards"
      converted_distance = self.distance * 0.0005681818239083977
    end

    @total = Total.find_or_initialize_by(user: self.user, starting_on: starting_on, range: "week")
    total_distance = converted_distance + @total.distance unless converted_distance.nil?
    total_duration = original_duration + @total.duration unless original_duration.nil?

    @total.distance = total_distance unless total_distance.nil?
    @total.duration = total_duration unless total_duration.nil?
    @total.save
  end

  def subtract_from_total
    week = self.date.to_date.cweek
    year = self.date.to_date.cwyear
    starting_on = Date.commercial(year, week)

    original_duration = self.duration
    case self.unit
    when "miles"
      converted_distance = self.distance
    when "kilometers"
      converted_distance = self.distance * 0.6213712
    when "meters"
      converted_distance = self.distance * 0.0006213711985
    when "yards"
      converted_distance = self.distance * 0.0005681818239083977
    end

    @total = Total.find_by(user: self.user, starting_on: starting_on, range: "week")
    unless @total.nil?
      @total.distance = @total.distance - converted_distance
      @total.duration = @total.duration - original_duration
      @total.save
    end
  end
end
