class ChangeDistanceInMilesOnTotals < ActiveRecord::Migration[7.0]
  def change
    rename_column(:totals, :distance, :distance_in_miles)
  end
end
