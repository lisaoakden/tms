module EnrollmentSubjectsHelper

	def get_start_date enrollment_subject
		if enrollment_subject.start_date.present?
			"Started on #{enrollment_subject.start_date.strftime("%d/%m/%Y")}"
		else 
			"Not started"
		end
	end

end
