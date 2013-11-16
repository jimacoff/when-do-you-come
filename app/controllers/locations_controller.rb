class LocationsController < ApplicationController

  def show
    @position = Position.find(params[:id])

    seconds = @position.remaining_time
    remaining_meters = @position.remaining_m
    total_meters = @position.total_m

    @remaining_time = sec_to_hour_min(seconds)

    @remaining_m = 100-remaining_m_to_percent(remaining_meters, total_meters)

    respond_to do |format|
      format.html
    end
  end

  def get_updated_position
    @actualPosition = Position.find(params[:location_id])

    render json: @actualPosition, only: [
      "actual_poi_lat", "actual_poi_lng", "remaining_m", "remaining_time"
    ]
  end
end
