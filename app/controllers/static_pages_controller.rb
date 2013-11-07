class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@enrollment_subjects =  current_user.enrollment_subjects 
  		@activities = current_user.activities.activities_course(current_user.current_course_id, 2)
  	end
  end
end
