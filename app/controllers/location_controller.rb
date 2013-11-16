class LocationController < ApplicationController

  def show
    #get session id

    #get route position

    @position = Position.find(params[:id])



    respond_to do |format|
      format.html
    end
  end


end
