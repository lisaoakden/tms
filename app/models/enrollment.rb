class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :conclusions 
  has_many :enrollment_subjects

  class << self 
    def activate! enrollment
    	enrollment.toggle! :activation
    	enrollment.course.course_subjects.each do |subject|
        subject_name = Subject.find(subject.subject_id).name
        enrollemt_subject = EnrollmentSubject.create!(enrollment_id: enrollment.id, 
          status: "new", name: subject_name)    
        subject.custom_courses.each do |t|
          task_name = t.task.name
          EnrollmentTask.create!(enrollment_subject_id: enrollemt_subject.id, status: "new", 
            name: task_name)
        end 
      end
    end
  end
end