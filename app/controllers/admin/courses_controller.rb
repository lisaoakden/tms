class Admin::CoursesController < ApplicationController
  def show
  	if supervisor_signed_in?
  		@supervisor = Supervisor.find params[:supervisor_id]
  		@course = @supervisor.courses.find params[:id]
  	else
  		redirect_to root_path
  	end
  end
end