class EnrollmentSubject < ActiveRecord::Base
	has_many :enrollment_tasks
	has_many :activities, foreign_key: "subject_id", class_name: "Activity"
	belongs_to :enrollment
	class << self
		def finish_subject! subject
			subject.update_attributes! status: "done"
		end
	end
	
	def task_done?
    self.status == "done"
  end
end