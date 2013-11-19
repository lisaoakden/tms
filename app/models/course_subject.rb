class CourseSubject < ActiveRecord::Base
  FINISH = "done"
  belongs_to :course
  belongs_to :subject
  has_many :course_subject_tasks

  accepts_nested_attributes_for :course_subject_tasks, 
  	reject_if: ->attributes {attributes["task_id"].blank?}

  def finish_date
  	self.start_date + self.duration.days
  end
  
  def done?
    self.status == FINISH
  end
end