class Admin::ConclusionsController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor
  
  def show
    @course = Course.find params[:course_id]
    @conclusions = Conclusion.all
  end
  
  def create
    
  end
  
  def update
    if params[:enrollment_ids]
      length = params[:enrollment_ids].length - 1 
      (0..length).each do |i|
        enroll = Enrollment.find params[:enrollment_ids][i]
        enroll.update_attributes(:conclusion_id => params[:conclusion_ids][i])
      end
      redirect_to admin_supervisor_course_path(current_supervisor, @course)
    end
  end
  
end