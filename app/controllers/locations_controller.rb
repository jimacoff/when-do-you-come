class LocationsController < ApplicationController

  def show
    #get session id

    #get route position
    position = Position.find(1) # TODO find by session id - need to change schema


    respond_to do |format|
      format.html
    end
  end


end