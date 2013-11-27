module TraineesHelper
  def current_course
  	Course.find current_trainee.current_course_id
  end
end