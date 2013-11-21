class Course < ActiveRecord::Base
  before_update :save_course_subject

  ACTIVE    = 1
  INACTIVE  = 0
  NEW       = "new"
	ACTIVATED = "start"
  DONE      = "done"
  
  has_many :enrollments
	has_many :activities,  foreign_key: "course_id", class_name: Activity.name
	has_many :users, through: :enrollments
	has_many :course_subjects
	has_many :subjects, through: :course_subjects
	has_many :supervisor_courses
	has_many :supervisors, through: :supervisor_courses

  accepts_nested_attributes_for :course_subjects, 
    reject_if: ->attributes {attributes["chosen"].blank?}

  scope :choose_course, ->course_id {find course_id}
  
  validates :name, presence: true, length: {minimum: 6}
  validates :start_date, presence: true
  validates :end_date, presence: true, is_after_start_date: true

  def activated?
    self.status != NEW
  end

  def inactivated?
    not activated?
  end

  def finished?
    self.status == DONE
  end

  def unfinished?
    not finished?
  end

  def duration
    ((self.end_date - self.start_date) / 1.day).to_i
  end
  
  def start
    self.update_attributes status: Course::ACTIVATED
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

  def full_course_subjects
    course_subject_hash = Hash.new
    course_subjects = self.course_subjects.where active_flag: ACTIVE
    course_subjects.each do |course_subject|
      course_subject_hash[course_subject.subject_id] = course_subject
    end
    subjects = Subject.find_all_by_active_flag ACTIVE
    full_course_subjects = []
    if subjects.present?
      subjects.each do |subject|
        if course_subject_hash.has_key? subject.id 
          course_subject = course_subject_hash[subject.id]
          course_subject.chosen = true
        else
          course_subject = CourseSubject.new subject_id: subject.id
          course_subject.chosen = false
        end
        full_course_subjects << course_subject
      end
    end
    full_course_subjects
  end

  def save_course_subject
    course_subjects.each do |course_subject|
      if course_subject.chosen.blank?
        if course_subject.id.blank?
          course_subjects.remove course_subject
        else
          course_subject.active_flag = INACTIVE
        end
      else
        course_subject.course_subject_tasks.each do |course_subject_task|
          if course_subject_task.chosen.blank?
            if course_subject_task.id.blank?
              course_subject_tasks.remove course_subject_task
            else
              course_subject_task.active_flag = INACTIVE
            end
          end
        end
      end
    end
  end
end