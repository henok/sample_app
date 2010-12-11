class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :new_user,   :only => [:new, :create]

  def index
    @title = "All users"
    @users = User.paginate({:page => params[:page], :per_page => 10})
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if(user == current_user)
      flash[:notice] = "cannot delete yourself"
      redirect_to users_path
    else
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
    
  end


  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      return redirect_to(signin_path) if (current_user.nil?)
      return redirect_to(root_path) unless (current_user.admin?)
    end

    def new_user
      return redirect_to(root_path) unless (current_user.nil?)
    end


end
