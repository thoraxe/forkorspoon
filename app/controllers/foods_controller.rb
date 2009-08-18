class FoodsController < ApplicationController

  before_filter :login_required

  def index
    @user = User.find(current_user, :include => :foods, :order => "foods.created_at ASC")
    @foods = @user.foods
    
    # create groups for each date
    @foodgroups = @foods.group_by{ |f| Date.civil(f.created_at.year, f.created_at.month, f.created_at.day) }

    # figure out the oldest date and the newest date
    @from_date = @foodgroups.keys.first
    @to_date = @foodgroups.keys.last

    # a food object for the form, just in case
    @food = Food.new
  end

  def create
    @user = User.find(current_user)
    params[:food][:created_at] = Time.zone.parse(params[:food][:created_at])
    @food = Food.new(params[:food])
    @user.foods << @food
    redirect_to foods_path
  end

  def edit
    @user = User.find(current_user)
    @food = Food.find(params[:id])
    if @user.id != @food.user_id
      flash[:error] = "Cheeky monkey, you can't edit what's not yours!"
      redirect_back_or_default(foods_path)
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
    redirect_back_or_default(foods_path)
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    redirect_to foods_path
  end

end
