class Activity < ActiveRecord::Base
  START_COURSE = 1
  EDIT_PROFILE = 2
  FINISH_TASK = 3
  FINISH_SUBJECT = 4
  FINISH_COURSE = 5
  belongs_to :trainee
  belongs_to :enrollment_task, foreign_key: "task_id", class_name: EnrollmentTask.name
  belongs_to :enrollment_subject, foreign_key: "subject_id", class_name: EnrollmentSubject.name
  belongs_to :course, foreign_key: "course_id", class_name: "Course"
  scope :order_desc_created_at, ->{order "created_at DESC"}
  scope :activities_course, ->course_id, temp_type do 
    where(course_id: course_id).where.not(temp_type: temp_type)
  end
  scope :activities_subject, ->subject_id {where subject_id: subject_id}
  
  class << self
    def trainee_edit! trainee
      Activity.create! trainee_id: trainee.id, temp_type: EDIT_PROFILE
    end

    def trainee_enroll! enrollment
      Activity.create! trainee_id: enrollment.trainee_id, course_id: enrollment.course_id, 
        temp_type: START_COURSE
    end

    def finish_subject! trainee, enrollment_subject
      Activity.create! trainee_id: trainee.id, course_id: trainee.current_course_id, 
        subject_id: enrollment_subject.id, temp_type: FINISH_SUBJECT
    end

    def finish_task! trainee, enrollment_task
      Activity.create! trainee_id: trainee.id, course_id: trainee.current_course_id, 
        subject_id: enrollment_task.enrollment_subject.id, task_id: enrollment_task.id,
        temp_type: FINISH_TASK
    end
  end
end