class UsersController < ApplicationController

  def index 
  end

  def show
    # want to pull 3 days per page. need to do some math on the page number to determine the date range
    # we wack off a second to get a datetime object.  we also use 1 second only to get inside the whole date
    if params[:page].blank? || params[:page].to_i == 1
      @start = Date.today - 2.days - 1.second
      @the_end = Date.today + 1.days - 1.second
    else
      @start = Date.today - (params[:page].to_i * 3 - 1).days - 1.second 
      @the_end = Date.today - (params[:page].to_i * 3 - 4).days - 1.second
    end

    @foods = Food.find(:all, :order => "created_at ASC", :conditions => { :user_id => current_user.id, :created_at => (@start.utc)..(@the_end.utc) } )
    
    # create groups for each date
    @foodgroups = @foods.group_by{ |f| Date.civil(f.created_at.year, f.created_at.month, f.created_at.day) }

    # figure out the oldest date and the newest date
    @from_date = @foodgroups.keys.first
    @to_date = @foodgroups.keys.last

    # a food object for the form, just in case
    @food = Food.new
    @foodtime = Time.zone.now.strftime("%m/%d/%Y %I:%M %p")
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_back_or_default(foods_path)
      flash[:notice] = "Updated successfully."
    else
      flash[:error] = "Could not update."
      render :action => 'edit'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
