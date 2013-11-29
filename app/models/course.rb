class Course < ActiveRecord::Base
  EXISTED = 0
  has_many :enrollments
  has_many :activities, foreign_key: "course_id", class_name: Activity.name
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

  validates :name, presence: true, length: {minimum: 6}
  validates :start_date, presence: true
  validates :end_date, presence: true, is_after_start_date: true

  def started?
    self.status == Settings.status.started
  end

  def has_trainee?
    self.users.count > EXISTED
  end

  def duration
    ((self.end_date - self.start_date) / 1.day).to_i
  end

  def start!
    self.users.each do |user|
      user.update_attribute(:current_course_id, self.id)
    end
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

  def assign_unassign trainees_assign, trainees_unassign
    trainees_assign.each do |trainee_assign|
      enroll = trainee_assign.enrollments.find_by self.id
      if enroll
        enroll.active_flag = Settings.flag.active
        self.enrollments << enroll
      else
        self.enrollments.build(user_id: trainee_assign.id, course_id: self.id, 
          status: Settings.status.new, active_flag: Settings.flag.active)
      end
    end
    trainees_unassign.each do |trainee_unassign|
      enroll = trainee_unassign.enrollments.find_by self.id
      enroll.active_flag = Settings.flag.inactive
      self.enrollments << enroll
    end
    self.update_attributes! status: Settings.status.new
  end

  def init_course_subjects
    course_subject_hash = Hash.new
    course_subjects = self.course_subjects.where active_flag: Settings.flag.active
    course_subjects.each do |course_subject|
      course_subject_hash[course_subject.subject_id] = course_subject
    end
    subjects = Subject.find_all_by_active_flag Settings.flag.active
    full_course_subjects = Array.new
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