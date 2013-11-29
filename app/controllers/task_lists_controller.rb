class TaskListsController < ApplicationController
  before_action :init_objects
  before_action :correct_trainee

  def show
  end

  def update
    if params[:task_ids]
      enrollment_tasks = @enrollment_subject.enrollment_tasks
        .find_all_by_id params[:task_ids]
      if check_update_done! enrollment_tasks
        flash[:success] = "Update successfully !" 
      end  
    end
    redirect_to trainee_enrollment_enrollment_subject_path params[:trainee_id],
      params[:enrollment_id], params[:enrollment_subject_id]
  end

  private
  def init_objects
    @trainee = Trainee.find params[:trainee_id]
    @enrollment = Enrollment.find params[:enrollment_id]
    @enrollment_subject = @enrollment.enrollment_subjects
      .find params[:enrollment_subject_id]
    unless current_trainee? @trainee && current_enrollment? && @enrollment_subject && @enrollment.activated?
      redirect_to @trainee
    end
  end

  def mark_as_done tasks
    tasks.map do |task|
      task.update_attributes! status: Settings.status.finished
    end.all?
  end

  def correct_trainee
    @trainee = Trainee.find params[:trainee_id]
    redirect_to root_url unless current_trainee? @trainee
  end

  def current_enrollment?
    @enrollment.course_id == @trainee.current_course_id
  end
  
  def check_update_done! tasks
    if mark_as_done tasks
      tasks.map do |task|
        Activity.finish_task! @trainee, task
      end.all?
    end
  end
end