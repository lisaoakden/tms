class Course < ActiveRecord::Base
  ACTIVE = 1
  INACTIVE = 0
	ACTIVATED = "start"
  has_many :enrollments
	has_many :activities,  foreign_key: "course_id", class_name: Activity.name
	has_many :users, through: :enrollments
	has_many :course_subjects
	has_many :subjects, through: :course_subjects
	has_many :supervisor_courses
	has_many :supervisors, through: :supervisor_courses

  accepts_nested_attributes_for :course_subjects, 
    reject_if: ->attributes {attributes["subject_id"].blank?}

  scope :choose_course, ->course_id {find course_id}
  
  validates :name, presence: true, length: {minimum: 6}
  validates :start_date, :end_date, presence: true

  def activated?
    self.status == ACTIVATED
  end

  def start
    self.update_attributes status: Course::ACTIVATED
  end 

  def course_duration
    ((self.end_date - self.start_date) / 1.day).to_i
  end

  def generate_form_data
    subjects = Subject.find_all_by_active_flag ACTIVE
    if subjects.present?
      subjects.each do |subject|
        course_subject = course_subjects.build subject_id: subject.id
        subject.tasks.each do |task|
          course_subject.course_subject_tasks.build task_id: task.id
        end
      end
    end
  end
end