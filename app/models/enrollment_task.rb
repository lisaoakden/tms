class EnrollmentTask < ActiveRecord::Base
	belongs_to :enrollment_subject
	scope :done_status, -> {where status: "done"}

	def task_done?
		self.status == "done"
	end
end
