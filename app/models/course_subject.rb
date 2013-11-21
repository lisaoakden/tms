class CourseSubject < ActiveRecord::Base
  attr_accessor :chosen

  #TODO use  gem https://github.com/pluginaweek/state_machine
  ACTIVE   = 1
  INACTIVE = 0
  FINISH   = "done"
  belongs_to :course
  belongs_to :subject
  has_many :course_subject_tasks

  accepts_nested_attributes_for :course_subject_tasks, 
  	reject_if: ->attributes {attributes["chosen"].blank?}

  def finish_date
  	self.start_date + self.duration.days
  end
  
  def done?
    self.status == FINISH
  end

  def full_course_subject_tasks
  	course_subject_task_hash = Hash.new
    course_subject_tasks = self.course_subject_tasks.where active_flag: ACTIVE
    course_subject_tasks.each do |course_subject_task|
      course_subject_task_hash[course_subject_task.task_id] = course_subject_task
    end
    tasks = Task.find_all_by_subject_id self.subject_id
    full_course_subject_tasks = []
    if tasks.present?
      tasks.each do |task|
        if course_subject_task_hash.has_key? task.id 
          course_subject_task = course_subject_task_hash[task.id]
          course_subject_task.chosen = true
        else
          course_subject_task = CourseSubjectTask.new task_id: task.id
          course_subject_task.chosen = false
        end
        full_course_subject_tasks << course_subject_task
      end
    end
    full_course_subject_tasks
  end
end