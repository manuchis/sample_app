class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])   
   end

   def show
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(:page => params[:page])
      @title = @user.name
    end
        
        def following
            @title = "Following"
            @user = User.find(params[:id])
            @users = @user.following.paginate(:page => params[:page])
            render 'show_follow'
          end

          def followers
            @title = "Followers"
            @user = User.find(params[:id])
            @users = @user.followers.paginate(:page => params[:page])
            render 'show_follow'
          end 
  def new
    redirect_to(root_path) unless !!current_user?(@user)
    @title = "Sign up"
    @user = User.new
  end
  
  def create
    redirect_to(root_path) unless !!current_user?(@user)
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
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
          flash[:success] = "Profile updated."
          redirect_to @user
        else
          @title = "Edit user"
          render 'edit'
        end
      end
      def destroy
          user = User.find(params[:id]) # Find the victim
            if (user == current_user) && (current_user.admin?)
              flash[:error] = "Suicide is immoral."
            else
              user.destroy
              flash[:notice] = "User destroyed".
            end
            redirect_to users_path
        end

   private

    def correct_user
         @user = User.find(params[:id])
         redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
end