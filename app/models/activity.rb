class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :shoe, optional: true

  scope :ordered, -> { order(date: :desc) }

  enum category: [:run, :long_run, :workout, :race, :other]
  enum difficulty: [:easy, :moderate, :hard]
  enum unit: [:miles, :kilometers, :meters, :yards]

  has_rich_text :description

  before_validation :calculate_duration
  before_save :calculate_distance_in_miles
  before_save :calculate_pace
  after_save :create_or_update_total
  after_destroy :create_or_update_total
  after_save :update_shoe_distance_in_miles

  validates :date, presence: true
  validates :distance, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }, presence: true
  validates :unit, presence: true
  validates :hours, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }
  validates :minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59, allow_nil: true }
  validates :seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59, allow_nil: true }

  private

  def calculate_distance_in_miles
    if self.unit.present? && self.distance.present?
      case self.unit
      when "miles"
        self.distance_in_miles = self.distance
      when "kilometers"
        self.distance_in_miles = self.distance * 0.6213712
      when "meters"
        self.distance_in_miles = self.distance * 0.0006213711985
      when "yards"
        self.distance_in_miles = self.distance * 0.0005681818239083977
      end
    end
  end

  def calculate_pace
    if (self.distance_in_miles.present? && self.duration)
      self.calculated_pace = self.duration / self.distance_in_miles
    end
  end

  def calculate_duration
    calculated_duration = 0
    
    calculated_duration += self.hours * (60 * 60) if self.hours.present?
    calculated_duration += self.minutes * 60 if self.minutes.present?
    calculated_duration += self.seconds if self.seconds.present?
    
    self.duration = calculated_duration unless calculated_duration == 0
  end

  def create_or_update_total
    starting_on = self.date.beginning_of_week

    @total = Total.find_or_initialize_by(user: self.user, starting_on: starting_on, range: "week")
    @activities = Activity.where("date >= ?", starting_on)
    .where("date <= ?", starting_on.end_of_week)
    .where(user: self.user)

    distance_in_miles = @activities.sum(:distance_in_miles) unless @activities.empty?
    total_duration = @activities.sum(:duration) unless @activities.empty?

    @total.distance_in_miles = distance_in_miles unless distance_in_miles.nil?
    @total.duration = total_duration unless total_duration.nil?
    @total.save
  end

  def update_shoe_distance_in_miles
    unless self.shoe.nil?
      @activities = Activity.where(shoe: self.shoe) 
      total_distance = @activities.sum(:distance_in_miles) unless @activities.empty?
      self.shoe.update(distance_in_miles: total_distance)
    end
  end
end
