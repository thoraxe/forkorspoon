class FoodsController < ApplicationController

  before_filter :login_required

  def index
  end

  def create
    if !params[:cancel]
      @user = User.find(current_user)
      params[:food][:created_at] = Time.zone.parse(params[:food][:created_at])
      @food = Food.new(params[:food])
      flash[:notice] = "nomnomnom!"
      @user.foods << @food
    end
    redirect_to(user_path(current_user))
  end

  def edit
    @user = User.find(current_user)
    @food = Food.find(params[:id])
    @foodtime = @food.created_at.strftime("%m/%d/%Y %I:%M %p")
    if @user.id != @food.user_id
      flash[:error] = "Cheeky monkey, you can't edit what's not yours!"
      redirect_back_or_default(user_path(current_user))
    end
  end

  def update
    if !params[:cancel]
      @food = Food.find(params[:id])
      if current_user.id == @food.user_id
        @food.update_attributes(params[:food])
        flash[:notice] = "Updated."
      else
        flash[:warning] = "Cheeky monkey, you can't edit what's not yours!"
      end
    end
    redirect_back_or_default(user_path(current_user))
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    redirect_back_or_default(user_path(current_user))
  end

end
