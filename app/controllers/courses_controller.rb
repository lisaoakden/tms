class CoursesController < ApplicationController
  def show
  	if signed_in?
  		@course = Course.find params[:id], include: @users
  	else
  		redirect_to root_url
  	end
  end
end