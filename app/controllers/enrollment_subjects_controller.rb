class EnrollmentSubjectsController < ApplicationController
  before_action :signed_in_trainee
  before_action :init_objects, only: [:show, :update]

  def index
    @trainee = Trainee.find params[:trainee_id]
    @enrollment = Enrollment.find params[:enrollment_id]
  end

  def show
    @subject = @enrollment_subject.subject
    @enrollment_task = @enrollment_subject.enrollment_tasks
    @activities = current_trainee.activities.order_desc_created_at
      .activities_subject @enrollment_subject.id
  end

  def update
    if complete_all_tasks?
      @enrollment_subject.finish_subject!
      Activity.finish_subject! @trainee, @enrollment_subject
      flash[:success] = "Congratulation! You have completed the #{@enrollment_subject.subject.name} subject"
    else
      flash[:error] = "You need to complete all tasks before finish subject"
    end
    redirect_to trainee_enrollment_enrollment_subject_path
  end

  private
  def init_objects
    @trainee = Trainee.find params[:trainee_id]
    @enrollment = Enrollment.find params[:enrollment_id]
    @enrollment_subject = EnrollmentSubject.find params[:id]
    unless current_trainee?(@trainee) && current_enrollment? && current_subject? && @enrollment.activated?
      flash[:error] = "You are restricted to view this subject :" + ((current_trainee? @trainee) && current_enrollment? && current_subject? && @enrollment.activated?).to_s
      unless @enrollment.activated?
        flash[:error] = "You must start this course before"
      end
      redirect_to trainee_enrollment_path(@trainee, @enrollment)
    end
  end

  def current_enrollment?
    @enrollment.course_id == @trainee.current_course_id
  end

  def current_subject? 
    @enrollment_subject.enrollment_id == @enrollment.id
  end

  def complete_all_tasks?
    @enrollment_subject.enrollment_tasks.all?{|task| task.done?}
  end
end