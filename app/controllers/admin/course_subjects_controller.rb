class Admin::CourseSubjectsController < ApplicationController
  before_action :correct_supervisor, only: [:update]

  def update
    @course_subject = CourseSubject.find params[:id]
    users = Enrollment.enrollment_subject_not_finish params[:course_id], params[:id]
    @course = current_supervisor.courses.find params[:course_id]
    if users.present?
      string_all_user_course_subject = users.collect(&:name).*(", ")
      flash[:success] = string_all_user_course_subject
      unless @course_subject.done?
        @course_subject.update_attributes! status: CourseSubject::FINISH
        users.each do |user|
          enrollment_subject = user.current_enrollment.enrollment_subjects
            .current_enrollment_subject(@course_subject.subject_id).first
          enrollment_subject.update_attributes! status: CourseSubject::FINISH
        end
      end
    end
    redirect_to admin_supervisor_course_path(current_supervisor.id, @course.id)
  end

  private
  def correct_supervisor
    supervisor = Supervisor.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end 
end