class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :enrollment_task, foreign_key: "task_id", class_name: "EnrollmentTask"
  belongs_to :enrollment_subject, foreign_key: "subject_id", class_name: "EnrollmentSubject"
  belongs_to :course, foreign_key: "course_id", class_name: "Course"
  START_COURSE = 1
  EDIT_PROFILE = 2
  FINISH_TASK = 3
  FINISH_SUBJECT = 4
  FINISH_COURSE = 5
	belongs_to :user
	scope :order_desc_created_at, ->{order "created_at DESC"}
	scope :activities_course, ->course_id, temp_type do 
    where(course_id: course_id).where.not(temp_type: temp_type)
  end
  scope :activities_subject, ->subject_id {where subject_id: subject_id}
  class << self
    def user_enroll! user_id, course_id
      Activity.create! user_id: user_id, course_id: course_id, temp_type: START_COURSE
    end

    def user_edit! user_id
      Activity.create! user_id: user_id, temp_type: EDIT_PROFILE
    end

    def finish_subject! user_id, course_id, subject_id
  	  Activity.create! user_id: user_id, course_id: course_id, subject_id: subject_id, temp_type: FINISH_SUBJECT
    end
  end
end