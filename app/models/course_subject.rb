class CourseSubject < ActiveRecord::Base
  belongs_to :course
  belongs_to :subject
  has_many :course_subject_tasks

  def end_date
  	self.start_date + (self.duration).days
  end
end