class Admin::TraineeListsController < ApplicationController
  def show
  end

  def update
    course = Course.find params[:course_id]
    if course.allocate! params[:trainee_ids]
      flash[:success] = "Course trainees updated successfully!"
    else
      flash[:error] = "Course trainees updated failed!"
    end
    redirect_to admin_supervisor_course_path current_supervisor, course
  end
end