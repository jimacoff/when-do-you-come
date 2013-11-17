class LocationsController < ApplicationController

  def show
    @position = Position.find(params[:id])

    seconds = @position.remaining_time
    remaining_meters = @position.remaining_m
    total_meters = @position.total_m

    @remaining_time = sec_to_hour_min(seconds)

    @remaining_m = remaining_m_to_percent(remaining_meters, total_meters)

    respond_to do |format|
      format.html
    end
  end

  def get_updated_position
    @actualPosition = Position.find(params[:location_id])

    seconds = @actualPosition.remaining_time
    remaining_meters = @actualPosition.remaining_m
    total_meters = @actualPosition.total_m

    @remaining_time = sec_to_hour_min(seconds)

    @remaining_m = remaining_m_to_percent(remaining_meters, total_meters)

    render json: {
      actualPosition: @actualPosition,
      remaining_m: @remaining_m,
      remaining_time: @remaining_time
    }
  end
end
