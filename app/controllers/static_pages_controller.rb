class StaticPagesController < ApplicationController
  def home
    if signed_in?
      enrollment = current_user.enrollments
       .find_by course_id: current_user.current_course_id
      redirect_to user_enrollment_path current_user, enrollment
    elsif supervisor_signed_in?
    	redirect_to admin_root_path
    end
  end
end
