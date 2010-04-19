class Admin::UsersController < Admin::AdminController

  make_resourceful do
    actions :create, :new, :destroy

    response_for :create do |format|
      format.html do
        flash[:user] = "User created successfully"
        redirect_to :action => :index
      end
    end
  end

  def index
    @users = User.all
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])

    if @user.save then
      return_or_redirect_to :action => :index
      flash[:user] = "User saved successfully"
    else
      render :action => :edit
    end
  end
end
