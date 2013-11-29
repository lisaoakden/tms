class EnrollmentsController < ApplicationController
  before_action :signed_in_trainee
  before_action :correct_trainee, only: :update
  
  def update
    trainee = Trainee.find params[:trainee_id], include: :enrollments
    if trainee
      enrollment = trainee.enrollments
        .find_by course_id: trainee.current_course_id
      if params[:activate] == "activate"
        if enrollment && enrollment.inactivated?
          enrollment.update_attributes status: Settings.status.started
          Activity.trainee_enroll! enrollment
          redirect_to root_url
        end
      end
    end
  end

  def show
    @enrollment = current_trainee.enrollments
      .find_by course_id: current_trainee.current_course_id
    @enrollment_subjects = @enrollment.enrollment_subjects
    @activities = current_trainee.activities.order_desc_created_at
      .activities_course(current_trainee.current_course_id,
      Activity::EDIT_PROFILE)
      .paginate(page: params[:page], per_page: Settings.items.per_page)
    @course = @enrollment.course
  end

  private
  def correct_trainee
    trainee = Trainee.find params[:trainee_id]
    redirect_to root_url unless current_trainee? trainee
  end
end