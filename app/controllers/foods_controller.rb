class FoodsController < ApplicationController

  before_filter :login_required

  def index
    @user = User.find(current_user, :include => :foods, :order => "foods.created_at ASC")
    @foods = @user.foods
    
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
