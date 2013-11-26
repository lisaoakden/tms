class EnrollmentTask < ActiveRecord::Base
	belongs_to :enrollment_subject
	belongs_to :subject
	belongs_to :task
	has_many :activities, foreign_key: "task_id", class_name: "Activity"
	scope :done_status, ->{where status: Settings.status.finished}

	def done?
		self.status == Settings.status.finished
	end
end