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
    @food = Food.new(params[:food])
    @user.foods << @food
    redirect_to foods_path
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    redirect_to foods_path
  end

end
