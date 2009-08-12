# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def status_box
    if logged_in?
      render :partial => 'shared/loggedin'
    else
      render :partial => 'shared/loggedout'
    end
  end
end
