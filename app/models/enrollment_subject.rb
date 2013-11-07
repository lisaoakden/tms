class EnrollmentSubject < ActiveRecord::Base
	has_many :enrollment_tasks
	belongs_to :enrollment

	def self.finish_subject subject
		subject.update_attributes status: "done"
	end
	
	def task_done?
    self.status == "done"
  end
end
