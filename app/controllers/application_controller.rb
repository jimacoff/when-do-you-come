class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  helper_method :convert_seconts_to_time

  def convert_seconts_to_time(seconds)
    Time.at(seconds).gmtime.strftime('%R:%S').to_i
  end

end
