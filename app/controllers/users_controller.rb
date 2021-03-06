class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Added "before_filer" so that only "logged in" users can 
  # access the user management section. [gpz/08142008]
  before_filter :login_required
  
  # Display all users in system. Create by [gpz 08142008]
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # Display a user's info. Create by [gpz 08142008]
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # Delete user from database. Create by [gpz 80142008]
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    redirect_to(users_url)
  end

  # Edit a user. Create by [gpz 80142008]
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # Update a user's information. Create by [gpz 80142008]
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was succressfully updated.'
      redirect_to(user_path(@user))
    else
      render :action => 'edit'
    end
  end
  
  # render new.rhtml
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
            redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
end
