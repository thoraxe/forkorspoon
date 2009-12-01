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
    # # this function is used to set the dates for the find statement when 
    # # pulling up food data. we take the page number and then return an
    # # array containing the dates. it is expected that you will pass in
    # # params[:page], which is a string, so we convert to i.
    # #
    # # want to pull 1 week per page. need to do some math on the page number to determine the date range
    # # we wack off a second to get a datetime object.  we also use 1 second only to get inside the whole date
    # if pagenum.blank? || pagenum.to_i == 1
    #   start = Date.today - Date.today.wday - 1.second
    #   the_end = Date.today + 1.days - 1.second
    # else
    #   # wack one off of the current page to figure out how many weeks we go back
    #   weeks = pagenum.to_i - 1
    #   start = Date.today - Date.today.wday - (weeks * 7).days - 1.second 
    #   the_end = Date.today - Date.today.wday - ((weeks - 1) * 7).days - 1.second
    # end

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
