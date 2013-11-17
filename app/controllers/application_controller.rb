class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  helper_method :convert_seconts_to_time, :sec_to_hour_min, :remaining_m_to_percent

  def convert_seconts_to_time(seconds)
    Time.at(seconds).gmtime.strftime('%R:%S').to_i
  end

  def sec_to_hour_min(seconds)
    hours = seconds / 3600
    seconds -= hours * 3600

    minutes = seconds / 60

    @res = hours.to_s + " hours  "+minutes.to_s+" minutes" if hours > 0
    @res = minutes.to_s+" minutes" if hours == 0

    return @res
  end

  def remaining_m_to_percent(remaining_meters, total_meters)
    puts "-citatel "+remaining_meters.to_s
    puts "-menovatel "+total_meters.to_s
    return ((remaining_meters.to_d / total_meters.to_d)*100).round
  end

end
