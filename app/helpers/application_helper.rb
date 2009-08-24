# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def status_box
    if logged_in?
      render :partial => 'shared/loggedin'
    else
      render :partial => 'shared/loggedout'
    end
  end
  
  def prev_link(page)
    return link_to "prev", user_path(current_user, :page => params[:page].to_i - 1) unless page.blank?
  end

  def next_link(page)
    if page.blank?
      link_to "next", user_path(current_user, :page => 2)
    else
      link_to "next", user_path(current_user, :page => params[:page].to_i + 1)
    end
  end
  
  def display_standard_flashes(message = 'There were some problems with your submission:')
    if flash[:notice]
      flash_to_display, level = flash[:notice], 'notice'
    elsif flash[:warning]
      flash_to_display, level = flash[:warning], 'warning'
    elsif flash[:error]
      level = 'error'
      if flash[:error].instance_of? ActiveRecord::Errors
        flash_to_display = message
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = flash[:error]
      end
    else
      return
    end
    content_tag 'div', flash_to_display, :class => "flash #{level}"
  end

  def activerecord_error_list(errors)
    error_list = '<ul class="error_list">'
    error_list << errors.collect do |e, m|
      "<li>#{e.humanize unless e == "base"} #{m}</li>"
    end.to_s << '</ul>'
    error_list
  end

end
