module AssignedTrainees
  def find_assigned_trainees course
  	@assigned_trainees = []
  	if course.enrollments
	    enrollments = course.enrollments.active
	    @assigned_trainees = enrollments.map{|enrollment| enrollment.trainee}
  	end
  end
end