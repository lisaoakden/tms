class Course < ActiveRecord::Base
	ACTIVATED = "start"
  has_many :enrollments
	has_many :activities,  foreign_key: "course_id", class_name: Activity.name
	has_many :users, through: :enrollments
	has_many :course_subjects
	has_many :subjects, through: :course_subjects
	has_many :supervisor_courses
	has_many :supervisors, through: :supervisor_courses

  scope :choose_course, ->course_id {find course_id}

  def activated?
    self.status == ACTIVATED
  end

  def course_duration
  	((self.end_date - self.start_date) / 1.day).to_i
  end
end