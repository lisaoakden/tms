module EnrollmentSubjectsHelper
	def get_start_date enrollment_subject
		if enrollment_subject.start_date.present?
			"Started on #{l enrollment_subject.start_date}"
		else 
			"Not started"
		end
	end
end
