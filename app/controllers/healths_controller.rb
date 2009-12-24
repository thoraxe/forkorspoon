class HealthsController < ApplicationController

  # make sure you are logged in before you can add a health
  before_filter :login_required

  def index
    # should probably redirect
  end

  def create
    @user = User.find(current_user) # you can only add to yourself
    params[:health][:created_at] = Time.zone.parse(params[:health][:created_at]) # we need to parse the time into the correct zone
    @health = Health.new(params[:health])
    flash[:notice] = "healthy!"
    @user.healths << @health
    redirect_to(userid_path(current_user.login))
  end

  def edit
    @user = User.find(current_user) # can only edit your own items
    @health = Health.find(params[:id])
    @nowtime = @health.created_at.strftime("%m/%d/%Y %I:%M %p") # create a string for the text box
    if @user.id != @health.user_id
      flash[:error] = "Cheeky monkey, you can't edit what's not yours!"
      redirect_back_or_default(userid_path(current_user.login))
    end
  end

  def update
    @health = Health.find(params[:id])
    if current_user.id == @health.user_id
      @health.update_attributes(params[:health])
      flash[:notice] = "Updated."
    else
      flash[:warning] = "Cheeky monkey, you can't edit what's not yours!"
    end
    redirect_back_or_default(userid_path(current_user.login))
  end

  def destroy
    @health = Health.find(params[:id])
    if @health.user_id == current_user.id
      @health.destroy
      flash[:notice] = "Deleted."
    else
      flash[:warning] = "Cheeky monkey, you can't edit what's not yours!"
    end
    redirect_back_or_default(userid_path(current_user.login))
  end

end
