class TrackingsController < ApplicationController

  def index
    respond_to do |format|
      format.html
    end
  end

  def show
    session["init"] = true

    if session[:id].nil?
      redirect_to root_path
    else
      puts "Session id: "+session[:id].to_s
      @position = Position.find(session[:id])

      seconds = @position.remaining_time
      remaining_meters = @position.remaining_m
      total_meters = @position.total_m

      @remaining_time = sec_to_hour_min(seconds)

      @remaining_m = remaining_m_to_percent(remaining_meters, total_meters)

    end
  end

  # Initial creating of route
  def init_route
    #session_id = request.session_options[:id]

    initial_position = Position.new(params)

    initial_position.a_timestamp = DateTime.now

    if initial_position.save
      # sucessfull creation
      session[:id] = initial_position.id

      link = "www.pinker.cz:5555/locations/"+initial_position.id.to_s

      PositionMailer.welcome_email(params[:mom_email], link).deliver

      render json: initial_position, only: ["id"]

    else
      # problem initializing
    end
  end

  def update_position

    actual_position = ""
    session["init"] = true

    if session[:id].nil?
      redirect_to root_path
    else
      actual_position = Position.find(session[:id])
    end

    status = ""

    # set :remaining_km, :tremaining_time, :actual_pois
    if actual_position.update_attributes(
      :remaining_m => params[:remaining_m],
      :actual_poi_lat => params[:actual_poi_lat],
      :actual_poi_lng => params[:actual_poi_lng],
      :remaining_time => params[:remaining_time]
      )

      status = "OK"
      # sucessfull updated
    else
      status = "NOT OK"
    end

    render json: {:status => status}

  end

  def cancel_route
    puts session[:id].to_s+"=================="
    Position.find(session[:id]).destroy
    reset_session

    redirect_to root_path
  end

end
