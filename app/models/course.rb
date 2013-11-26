class Course < ActiveRecord::Base
  EXIST     = 0
  
  before_update :save_course_subject
  has_many :enrollments
	has_many :activities,  foreign_key: "course_id", class_name: Activity.name
	has_many :users, through: :enrollments
	has_many :course_subjects
	has_many :subjects, through: :course_subjects
	has_many :supervisor_courses
	has_many :supervisors, through: :supervisor_courses
  has_many :current_users, class_name: User.name, foreign_key: :current_course_id

  accepts_nested_attributes_for :course_subjects, reject_if: ->attributes do
    attributes[:active_flag] == Settings.flag.inactive.to_s && attributes[:id].blank?
  end
  accepts_nested_attributes_for :enrollments

  scope :choose_course, ->course_id {find course_id}

  validates :name, presence: true, length: {minimum: 6}
  validates :start_date, presence: true
  validates :end_date, presence: true, is_after_start_date: true

  def started?
    self.status == Settings.status.started
  end

  def has_trainee?
    self.users.count > EXIST
  end

  def duration
    ((self.end_date - self.start_date) / 1.day).to_i
  end

  def start!
    self.enrollments.each do |enrollment| 
      self.course_subjects.each do |course_subject|
        enrollment_subject = enrollment.enrollment_subjects.build(
          subject_id: course_subject.subject_id, status: Settings.status.new, 
          course_id: enrollment.course_id, user_id: enrollment.user_id)
        course_subject.course_subject_tasks.each do |course_subject_task|
          enrollment_subject.enrollment_tasks.build(
            subject_id: course_subject.subject_id, 
            task_id: course_subject_task.task_id, status: Settings.status.new)
        end
      end
      enrollment.status = Settings.status.started
      enrollment.user.current_course_id = self.id
    end
    self.update_attributes! status: Settings.status.started
  end

  def generate_form_data
    subjects = Subject.where active_flag: Settings.flag.active
    if subjects.present?
      subjects.each do |subject|
        course_subject = course_subjects.build subject_id: subject.id
        subject.tasks.each do |task|
          course_subject.course_subject_tasks.build task_id: task.id
        end
      end
    end
  end

  def full_course_subjects
    course_subject_hash = Hash.new
    course_subjects = self.course_subjects.where active_flag: Settings.flag.active
    course_subjects.each do |course_subject|
      course_subject_hash[course_subject.subject_id] = course_subject
    end
    subjects = Subject.find_all_by_active_flag Settings.flag.active
    full_course_subjects = []
    if subjects.present?
      subjects.each do |subject|
        if course_subject_hash.has_key? subject.id 
          course_subject = course_subject_hash[subject.id]
        else
          course_subject = CourseSubject.new subject_id: subject.id,
            active_flag: Settings.flag.inactive
        end
        full_course_subjects << course_subject
      end
    end
    full_course_subjects
  end
end