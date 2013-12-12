class EnrollmentsController < ApplicationController
  before_action :signed_in_trainee
  before_action :correct_trainee, only: :update
  
  def update
    trainee = Trainee.find params[:trainee_id], include: :enrollments
    if trainee
      enrollment = trainee.enrollments
        .find_by course_id: trainee.current_course_id
      course = Course.find trainee.current_course_id
      if params[:activate] == "activate"
        if enrollment && enrollment.inactivated?
          course.course_subjects.each do |course_subject|
            enrollment_subject = enrollment.enrollment_subjects.build(
              subject_id: course_subject.subject_id, course_id: course.id,
              trainee_id: trainee.id, status: Settings.status.new,
              start_date: DateTime.current() )
            course_subject.course_subject_tasks.each do |course_subject_task|
              enrollment_subject.enrollment_tasks.build(
                subject_id: course_subject.subject_id,
                task_id: course_subject_task.task_id, status: Settings.status.new )
            end
          end
          enrollment.update_attributes! status: Settings.status.started
          Activity.trainee_enroll! enrollment
          redirect_to root_url
        end
      end
    end
  end

  def show
    @enrollment = current_trainee.enrollments
      .find_by course_id: current_trainee.current_course_id
    @enrollment_subjects = @enrollment.enrollment_subjects
    @activities = current_trainee.activities.order_desc_created_at
      .activities_course(current_trainee.current_course_id,
      Activity::EDIT_PROFILE)
      .paginate(page: params[:page], per_page: Settings.items.per_page)
    @course = @enrollment.course
  end

  private
  def correct_trainee
    trainee = Trainee.find params[:trainee_id]
    redirect_to root_url unless current_trainee? trainee
  end
end