class TaskListsController < ApplicationController
  before_action :load_object, only: [:index, :show, :update]

  def index
  end

  def show
		@enrollment_task = @enrollment_subject.enrollment_tasks.build
  end

  def update
    if params[:enrollment_task]
      finish_tasks = EnrollmentTask.find params[:enrollment_task][:finish]
      finish_tasks.each do |task|
      	task.update_attributes status: "done"
        
        flash[:success] = "Updated"
      end

    end
    redirect_to user_enrollment_enrollment_subject_path(params[:user_id], params[:enrollment_id], params[:id])
  end

  private
  def load_object
    @user = User.find params[:user_id]
    @enrollment = Enrollment.find params[:enrollment_id]
    @enrollment_subject = EnrollmentSubject.find params[:id]
  end
end