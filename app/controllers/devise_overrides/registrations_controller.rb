class DeviseOverrides::RegistrationsController < Devise::RegistrationsController
before_action :authenticate_user!
skip_before_action :require_no_authentication, only: [:new, :create, :edit, :update, :destroy]

  def new
    build_user
    # authorize build_user
  end

  def edit
     load_user
     # authorize load_user
     build_user
  end
  def create
    build_user
    save_user or render 'new'
  end

  def update
    load_user
    # authorize @user
    build_user
    save_user or render 'edit'
  end

  def destroy
    load_user
    # authorize @user
    @user.destroy
    redirect_to users_path, notice: "Employee access deactivated successfully."
  end

end
private
  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(:username, :password, :password_confirmation, :email, :role, :type) : {}
  end
  def load_users
    @users ||= user_scope.to_a
  end
  def load_user
    @user ||= user_scope.find(params[:id])
  end
  def build_user
    @user ||= user_scope.build
    authorize @user
    @user.attributes = user_params
  end
  def save_user
    if @user.save
      redirect_to admin_root_path,:notice => "registered successfully."
    end
  end
  def user_scope
    User.all
  end