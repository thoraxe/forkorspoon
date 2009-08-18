class FoodsController < ApplicationController

  before_filter :login_required

  def index
  end

  def create
    @user = User.find(current_user)
    params[:food][:created_at] = Time.zone.parse(params[:food][:created_at])
    @food = Food.new(params[:food])
    @user.foods << @food
    redirect_to users_path
  end

  def edit
    @user = User.find(current_user)
    @food = Food.find(params[:id])
    if @user.id != @food.user_id
      flash[:error] = "Cheeky monkey, you can't edit what's not yours!"
      redirect_back_or_default(users_path)
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
    redirect_back_or_default(users_path)
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    redirect_to users_path
  end

end
