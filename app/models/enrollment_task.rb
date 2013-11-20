class EnrollmentTask < ActiveRecord::Base
	DONE = "done"
	belongs_to :enrollment_subject
	belongs_to :subject
	belongs_to :task
	has_many :activities, foreign_key: "task_id", class_name: "Activity"
	scope :done_status, ->{where status: DONE}

	def done?
		self.status == DONE
	end
end