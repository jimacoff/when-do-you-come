class LocationsController < ApplicationController

  def show
    #@position = Position.find(params[:id]) # TODO find by session id - need to change schema
    @position = Position.find(1)

    respond_to do |format|
      format.html
    end
  end


end
