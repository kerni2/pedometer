class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.activities.ordered.ransack(params[:q])
    @pagy, @activities = pagy(current_user.activities)
  end

  def show
    authorize @activity
  end
  
  def new
    @activity = current_user.activities.build(date: Time.zone.now)
  end

  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      redirect_to @activity, notice: "Created Activity"
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    authorize @activity
  end

  def update
    authorize @activity
    if @activity.update(activity_params)
      redirect_to @activity, notice: "Edited Activity"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    authorize @activity
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_path, notice: "Activity Deleted" }
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:hours, :minutes, :seconds, :category, :distance, :difficulty, :unit, :date, :description, :shoe_id)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end
end
