class Admin::CourseSubjectsController < ApplicationController
  before_action :correct_supervisor

  def update
    @course_subject = CourseSubject.find params[:id]
    trainees = EnrollmentSubject.trainees_not_finish_subject params[:course_id],
      @course_subject.subject_id
    @course = current_supervisor.courses.find params[:course_id]
    if @course_subject.unfinished?
      @course_subject.update_attributes! status: Settings.status.finished
      if trainees.present?
        trainees.each do |trainee|
          enrollment = trainee.enrollments.find_by course_id: trainee.current_course_id
          enrollment_subject = enrollment.enrollment_subjects
            .find_by subject_id: @course_subject.subject_id
          enrollment_subject.update_attributes! status: Settings.status.finished
        end
        string_all_trainee_course_subject = trainees.collect(&:name).join ", "
        flash[:success] = string_all_trainee_course_subject
      end
      string_all_trainee_course_subject = trainees.collect(&:name).join ", "
      flash[:success] = string_all_trainee_course_subject
    end
    redirect_to admin_supervisor_course_path current_supervisor, @course
  end

  private
  def correct_supervisor
    supervisor = Supervisor.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end
end