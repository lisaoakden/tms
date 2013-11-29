class StaticPagesController < ApplicationController
  def home
    if signed_in?
      enrollment = current_trainee.enrollments
        .find_by course_id: current_trainee.current_course_id
      redirect_to trainee_enrollment_path current_trainee, enrollment
    elsif supervisor_signed_in?
      redirect_to admin_root_path
    else
      redirect_to signin_path
    end
  end
end
