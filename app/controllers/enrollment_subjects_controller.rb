class EnrollmentSubjectsController < ApplicationController
	before_action :signed_in_user
	before_action :init_objects, only: [:show, :update]

  def index
    @user = User.find params[:user_id]
    @enrollment = Enrollment.find params[:enrollment_id]
  end

  def show
    @subject = @enrollment_subject.subject
    @enrollment_task = @enrollment_subject.enrollment_tasks
    @activities = current_user.activities.order_desc_created_at
      .activities_subject @enrollment_subject.id
  end

  def update
  	if complete_all_tasks?
      @enrollment_subject.finish_subject!
      Activity.finish_subject! @user, @enrollment_subject
      flash[:success] = "Congratulation! You have completed the  #{@enrollment_subject.subject.name} subject"
    else
      flash[:error] = "You need to complete all tasks before finish subject"
    end
  	redirect_to user_enrollment_enrollment_subject_path
  end

  private
  def init_objects
  	@user = User.find params[:user_id]
  	@enrollment = Enrollment.find params[:enrollment_id]
  	@enrollment_subject = EnrollmentSubject.find params[:id]
  	unless current_user?(@user) && current_enrollment? && current_subject? && @enrollment.activated?
  		redirect_to @user
  	end
  end

  def current_enrollment?
    @enrollment.course_id == @user.current_course_id
  end

  def current_subject? 
  	@enrollment_subject.enrollment_id == @enrollment.id
  end

  def complete_all_tasks?
    @enrollment_subject.enrollment_tasks.all?{|task| task.done?}
  end
end