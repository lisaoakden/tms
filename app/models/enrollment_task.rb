class EnrollmentTask < ActiveRecord::Base
	belongs_to :enrollment_subject
	belongs_to :subject
	belongs_to :task
	scope :done_status, -> {where status: "done"}
	has_many :activities, foreign_key: "task_id", class_name: "Activity"
	def task_done?
		self.status == "done"
	end
end
