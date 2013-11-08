class EnrollmentTask < ActiveRecord::Base
	belongs_to :enrollment_subject

	def task_done?
    self.status == "done"
  end
end
