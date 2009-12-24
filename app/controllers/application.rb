# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  # pull in restful auth
  include AuthenticatedSystem

  # set time zone for user
  before_filter :set_time_zone

  def set_time_zone
    Time.zone = @current_user.time_zone if @current_user
  end

  def week_calculator(pagenum)
    # this function calculates the start and end dates for a 7 day period from Monday to Sunday
    # either by looking at today's date when no parameters are specified, or based on a 
    # week/year coming in from the params
    if params[:year].blank? || params[:week].blank?
      today = Date.today
      if today.wday == 0
        start = Time.zone.local(today.year, today.month, today.day) - 6.days
      else
        start = Time.zone.local(today.year, today.month, today.day) - (today.wday - 1).days
      end
      the_end = start + 7.days - 1.second
    else
      start =   DateTime.commercial(params[:year].to_i, params[:week].to_i, 1,0,0,0,DateTime.now.offset)
      the_end = DateTime.commercial(params[:year].to_i, params[:week].to_i, 7,0,0,0,DateTime.now.offset) + 1.day - 1.second
    end

    return [start,the_end]
  end

end
