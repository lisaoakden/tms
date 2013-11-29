class CoursesController < ApplicationController
	before_action :signed_in_user

  def show
  	@course = Course.find params[:id], include: @users
  end
end