class FoodsController < ApplicationController

  # make sure you are logged in before you can add food
  before_filter :login_required

  def index
    # should probably redirect
  end

  def create
    @user = User.find(current_user)
    params[:food][:created_at] = Time.zone.parse(params[:food][:created_at])
    @food = Food.new(params[:food])
    flash[:notice] = "nomnomnom!"
    @user.foods << @food
    redirect_to(userid_path(current_user.login))
  end

  def edit
    @user = User.find(current_user)
    @food = Food.find(params[:id])
    @nowtime = @food.created_at.strftime("%m/%d/%Y %I:%M %p") # create a string for the text box
    if @user.id != @food.user_id
      flash[:error] = "Cheeky monkey, you can't edit what's not yours!"
      redirect_back_or_default(userid_path(current_user.login))
    end
  end

  def update
    @food = Food.find(params[:id])
    if current_user.id == @food.user_id
      @food.update_attributes(params[:food])
      flash[:notice] = "Updated."
    else
      flash[:warning] = "Cheeky monkey, you can't edit what's not yours!"
    end
    redirect_back_or_default(userid_path(current_user.login))
  end

  def destroy
    @food = Food.find(params[:id])
    if @food.user_id == current_user.id
      @food.destroy
      flash[:notice] = "Deleted."
    else
      flash[:warning] = "Cheeky monkey, you can't edit what's not yours!"
    end
    redirect_back_or_default(userid_path(current_user.login))
  end

end
