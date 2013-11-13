class TaskListsController < ApplicationController
  before_action :create_objects, only: [:update, :show]
  before_action :correct_user, only: [:update, :show]

  def show
  end

  def update
    if params[:task_ids]
      enrollment_tasks = @enrollment_subject.enrollment_tasks
        .find_all_by_id params[:task_ids]
      flash[:success] = "Update successfull!" if check_update_done! enrollment_tasks
    end
    
    redirect_to user_enrollment_enrollment_subject_path params[:user_id], 
      params[:enrollment_id], params[:enrollment_subject_id]
  end

  private
  def create_objects
    @user = User.find params[:user_id]
    @enrollment = Enrollment.find params[:enrollment_id]
    @enrollment_subject = @enrollment.enrollment_subjects
      .find params[:enrollment_subject_id]
    unless current_user?(@user) && current_enrollment? && 
      @enrollment_subject && @enrollment.activated?
      redirect_to @user
    end
  end

  def mark_as_done tasks
    tasks.map do |task|
      task.update_attributes status: "done"
    end.all?
  end

  def correct_user
    @user = User.find params[:user_id]
    redirect_to root_url unless current_user? @user
  end

  def current_enrollment?
    @enrollment.course_id == @user.current_course_id
  end
  def check_update_done! tasks
    if mark_as_done tasks
      tasks.map do |task|
        Activity.finish_task! @user, task
      end.all?
    end
  end
end