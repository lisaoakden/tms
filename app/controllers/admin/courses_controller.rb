class Admin::CoursesController < ApplicationController
  def show
  	if supervisor_signed_in?
      @supervisor = Supervisor.find params[:supervisor_id]
      @course = @supervisor.courses.find params[:id]
  	else
  		redirect_to root_path
  	end
  end

  def index
    if supervisor_signed_in?
      @supervisor = Supervisor.find params[:supervisor_id]
      @courses = @supervisor.courses.paginate page: params[:page],
        per_page:Settings.items.per_page
    else
      redirect_to root_url
    end
  end
end