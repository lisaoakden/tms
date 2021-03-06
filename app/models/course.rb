class Course < ActiveRecord::Base
  include Active
  
  EXISTED = 0
  has_many :enrollments
	has_many :activities, foreign_key: "course_id", class_name: Activity.name
	has_many :trainees, through: :enrollments
	has_many :course_subjects
	has_many :subjects, through: :course_subjects
	has_many :supervisor_courses
	has_many :supervisors, through: :supervisor_courses
  has_many :current_trainees, class_name: Trainee.name, foreign_key: :current_course_id

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
  
  def finished?
    self.status == Settings.status.finished
  end

  def has_trainee?
    self.trainees.count > EXISTED
  end

  def duration
    ((self.end_date - self.start_date) / 1.day).to_i
  end

  def start!
    self.trainees.each do |trainee|
      trainee.update_attributes current_course_id: self.id
    end
    self.update_attributes! status: Settings.status.started
  end
  
  def all_subject_finished?
    self.enrollments.active.each do |enrollment|
      enrollment.enrollment_subjects.active.each do |enrollment_subject|
        if enrollment_subject.status != Settings.status.finished
          return false
        end
      end
    end
    true
  end
  
  def finish!
    self.enrollments.active.each do |enrollment|
      enrollment.enrollment_subjects.active.each do |enrollment_subject|
        enrollment_subject.status = Settings.status.finished
      end
      enrollment.status = Settings.status.finished
    end
    self.course_subjects.each do |course_subject|
      course_subject.status = Settings.status.finished
    end
    self.update_attributes! status: Settings.status.finished
  end

  def allocate! ids
    selected_trainees = Trainee.selected_trainees ids
    if selected_trainees.present?
      deselected_trainees = self.trainees - selected_trainees
      selected_trainees.each do |selected_trainee|
        enroll = selected_trainee.enrollments.find_by self.id
        if enroll
          enroll.active_flag = Settings.flag.active
          self.enrollments << enroll
        else
          self.enrollments.build(trainee_id: selected_trainee.id, course_id: self.id, 
            status: Settings.status.new, active_flag: Settings.flag.active)
        end
      end
    else
      deselected_trainees = self.trainees
    end
    if deselected_trainees.present?
      deselected_trainees.each do |deselected_trainee|
        enroll = deselected_trainee.enrollments.find_by self.id
        enroll.active_flag = Settings.flag.inactive
        self.enrollments << enroll
      end
    end
    self.update_attributes! status: Settings.status.new
  end

  def init_course_subjects
    course_subject_hash = Hash.new
    course_subjects = self.course_subjects.active
    course_subjects.each do |course_subject|
      course_subject_hash[course_subject.subject_id] = course_subject
    end
    subjects = Subject.active
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

  def trainees 
    if self.enrollments
      enrollments = self.enrollments.active
      enrollments.map{|enrollment| enrollment.trainee}
    end
  end
  
  def delete! (supervisor_id)
    supervisorCourse = self.supervisor_courses.find_by_supervisor_id(supervisor_id)
    supervisorCourse.active_flag = Settings.flag.inactive
    supervisorCourse.save!
    self.enrollments.active.each do |enrollment|
      enrollment.active_flag = Settings.flag.inactive
      enrollment.enrollment_subjects.active.each do |enrollment_subject|
        enrollment_subject.active_flag = Settings.flag.inactive
        enrollment_subject.enrollment_tasks.each do |enrollment_task|
          enrollment_task.active_flag = Settings.flag.inactive
        end
      end
    end
    self.course_subjects.active.each do |course_subject|
      course_subject.active_flag = Settings.flag.inactive
      course_subject.course_subject_tasks.active.each do |course_subject_tasks|
        course_subject_tasks.active_flag = Settings.flag.inactive
      end
    end
    self.update_attributes! active_flag: Settings.flag.inactive
  end
end