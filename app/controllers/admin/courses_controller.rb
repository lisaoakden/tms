class Admin::CoursesController < ApplicationController
  before_action :correct_supervisor, only: [:update]

  def update
    if supervisor_signed_in?
      @course = current_supervisor.courses.find params[:id]
      unless @course.activated?
        @course.update_attributes status: "start"
      end
      redirect_to admin_supervisor_course_path(current_supervisor.id, @course.id)
    else
      redirect_to root_path
    end
  end

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

  private
  def correct_supervisor
    supervisor = Supervisor.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end 
end