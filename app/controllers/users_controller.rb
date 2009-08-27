class UsersController < ApplicationController

  # heavily modified restful_authentication

  def index 
    if logged_in?
      redirect_to user_path(current_user)
    end
  end

  def show
    @user = User.find(params[:id])

    @start,@the_end = week_calculator(params[:page])

    @foods = Food.find(:all, :order => "created_at ASC", :conditions => { :user_id => params[:id], :created_at => (@start.utc)..(@the_end.utc) } )
    
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
    if !params[:cancel]
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:notice] = "Updated successfully."
      else
        flash[:error] = "Could not update."
        render :action => 'edit'
      end
    end
    redirect_back_or_default(user_path(current_user))
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

  # forgot password stuff
  def forgot  
    if request.post?  
      if !params[:cancel]
        user = User.find_by_email(params[:user][:email])  
    
        respond_to do |format|  
          if user  
            user.create_reset_code  
            flash[:notice] = "Reset code sent to #{user.email}"  
    
            format.html { redirect_to login_path }  
            format.xml { render :xml => user.email, :status => :created }  
          else  
            flash[:error] = "#{params[:user][:email]} does not exist in system"  
    
            format.html { redirect_to login_path }  
            format.xml { render :xml => user.email, :status => :unprocessable_entity }  
          end  
        end  
      else
        redirect_back_or_default('/')
      end
    end  
  end  

  def reset  
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?  
    if request.post?  
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])  
        self.current_user = @user  
        @user.delete_reset_code  
        flash[:notice] = "Password reset successfully for #{@user.email}"  
        redirect_to root_url  
      else  
        render :action => :reset  
      end  
    end  
  end 

end
