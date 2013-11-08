class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :load_object,    only: [:show, :edit, :update]

  def show
    @subjects = @user.have_subjects.paginate page: params[:page], per_page: 3
    @activities = current_user.activities
    if signed_in?
      render :show
    else
      redirect_to root_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      user_edit(@user.id)
      redirect_to @user
    else
      render :edit
    end
  end

  def create
  end

  private
  def user_params
    params.require(:user)
      .permit(:name, :password, :password_confirmation)
  end

  def signed_in_user
    unless signed_in?
      store_location!
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def load_object
    @user = User.find params[:id]
  end
  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? @user
  end 

  def user_enroll user_id,course_id
    Activity.create! user_id: user_id,course_id: course_id, temp_type: 1
  end

  def user_edit user_id
    Activity.create! user_id: user_id, temp_type: 2
  end
end
