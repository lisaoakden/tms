class EnrollmentSubject < ActiveRecord::Base
  include Active
  
  belongs_to :enrollment
  belongs_to :subject
  has_many :enrollment_tasks
  has_many :activities, foreign_key: "subject_id", class_name: Activity.name

  accepts_nested_attributes_for :enrollment_tasks
  
  scope :finished_subject, ->{where status: Settings.status.finished}
  scope :current_enrollment_subject, ->subject_id{where subject_id: subject_id}
  scope :course_subject_not_finish, ->course_id, subject_id do
    where course_id: course_id, subject_id: subject_id, status: Settings.status.new
  end

  def finish_subject!
    self.update_attributes! status: Settings.status.finished
  end

  def done?
    self.status == Settings.status.finished
  end
  
  def all_task_finished?
    self.enrollment_tasks.active.each do |enrollment_task|
      return false unless enrollment_task.done?
    end
    true
  end

  def end_date
    self.start_date + self.subject.duration.day
  end
  
  class << self
    def trainees_not_finish_subject course_id, subject_id
      relations = course_subject_not_finish course_id, subject_id
      users = relations.map{|relation| Trainee.find relation.trainee_id}
    end
  end
end