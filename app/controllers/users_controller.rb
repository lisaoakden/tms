class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
    if signed_in?
      render :show
    else
      redirect_to root_url
    end
  end

  def start_course

  end

  def create
  end

  private
  def user_params
    params.require(:user)
      .permit(:name, :email, :password, :password_confirmation)
  end
end
