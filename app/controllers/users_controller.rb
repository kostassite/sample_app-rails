class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update,:destroy, :following ,:followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :guest_user, only:[:new, :create]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page:params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user]) 
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
    else
      render 'new' end
    end
    
    def edit
      @user = User.find(params[:id]) 
    end
    
    def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        sign_in @user
        redirect_to @user
      else
        render 'edit'
      end
    end
    
    
    def index
      @users = User.paginate(page: params[:page])
    end

    def destroy
      userToDelete=User.find(params[:id]);
      if current_user == userToDelete
        flash[:error] = "You cannot delete yourself"
        redirect_to users_path
      else
        userToDelete.destroy
        flash[:success] = "User destroyed"
        redirect_to users_path
      end
    end
    
    def following
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.followed_users.paginate(page: params[:page]) 
      render 'show_follow'
    end
    def followers
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page]) 
      render 'show_follow'
    end
    
    private
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def guest_user
      redirect_to(root_path) unless !signed_in?
    end
end

