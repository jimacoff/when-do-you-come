class LocationsController < ApplicationController

  def show
    @position = Position.find(params[:id])

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
