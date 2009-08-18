# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # pull in restful auth
  include AuthenticatedSystem

  # set time zone for user
  before_filter :set_time_zone

  def set_time_zone
    Time.zone = @current_user.time_zone if @current_user
  end

end
