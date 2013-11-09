module EnrollmentsHelper
	def enrollment_activation? enrollment
		enrollment.status == 1
	end
end
