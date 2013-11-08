class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@enrollment = current_user.enrollments.find_by course_id: current_user.current_course_id
  		@enrollment_subjects = current_user.enrollment_subjects 
  		@activities = current_user.activities.activities_course(current_user.current_course_id, 2)
  	end
  end
end
