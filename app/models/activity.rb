class Activity < ActiveRecord::Base
  TEMP_TYPE = 2
  START_COURSE = 1
  EDIT_PROFILE = 2
  FINISH_TASK = 3
  FINISH_SUBJECT = 4
  FINISH_COURSE = 5
  belongs_to :user
  belongs_to :enrollment_task, foreign_key: "task_id", class_name: EnrollmentTask.name
  belongs_to :enrollment_subject, foreign_key: "subject_id", class_name: EnrollmentSubject.name
  belongs_to :course, foreign_key: "course_id", class_name: "Course"
	scope :order_desc_created_at, ->{order "created_at DESC"}
	scope :activities_course, ->course_id, temp_type do 
    where(course_id: course_id).where.not(temp_type: temp_type)
  end
  scope :activities_subject, ->subject_id {where subject_id: subject_id}
  class << self
    def user_edit! user
      Activity.create! user_id: user.id, temp_type: EDIT_PROFILE
    end
    def user_enroll! enrollment
      Activity.create! user_id: enrollment.user_id, course_id: enrollment.course_id, 
        temp_type: START_COURSE
    end

    def finish_subject! user, enrollment_subject
      Activity.create! user_id: user.id, course_id: user.current_course_id, 
        subject_id: enrollment_subject.id, temp_type: FINISH_SUBJECT
    end

    def finish_task! user, enrollment_task
      Activity.create! user_id: user.id, course_id: user.current_course_id, 
        subject_id: enrollment_task.enrollment_subject.id, task_id: enrollment_task.id,
         temp_type: FINISH_TASK
    end
  end
end