class CourseSubject < ActiveRecord::Base
  include Active

  belongs_to :course
  belongs_to :subject
  has_many :course_subject_tasks

  accepts_nested_attributes_for :course_subject_tasks, reject_if: ->attributes do
    attributes[:active_flag] == Settings.flag.inactive.to_s && attributes[:id].blank?
  end

  def finish_date
  	self.start_date + self.duration.days
  end

  def unfinished?
    self.status != Settings.status.finished
  end

  def init_course_subject_tasks
  	course_subject_task_hash = Hash.new
    course_subject_tasks = self.course_subject_tasks.active
    course_subject_tasks.each do |course_subject_task|
      course_subject_task_hash[course_subject_task.task_id] = course_subject_task
    end
    tasks = Task.active.sort_asc.find_all_by_subject_id self.subject_id
    full_course_subject_tasks = Array.new
    if tasks.present?
      tasks.each do |task|
        if course_subject_task_hash.has_key? task.id 
          course_subject_task = course_subject_task_hash[task.id]
        else
          course_subject_task = CourseSubjectTask.new task_id: task.id,
            active_flag: Settings.flag.inactive
        end
        full_course_subject_tasks << course_subject_task
      end
    end
    full_course_subject_tasks
  end
end