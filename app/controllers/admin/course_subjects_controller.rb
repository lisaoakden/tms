class Admin::CourseSubjectsController < ApplicationController
  before_action :correct_supervisor, only: [:update]

  def update
    @course_subject = CourseSubject.find params[:id]
    users = Enrollment.enrollment_subject_not_finish params[:course_id],
      @course_subject.subject_id
    @course = current_supervisor.courses.find params[:course_id]
    if @course_subject.not_done?
      @course_subject.update_attributes! status: CourseSubject::FINISH
      if users.present?
        users.each do |user|
          enrollment_subject = user.current_enrollment.enrollment_subjects
            .find_by subject_id: @course_subject.subject_id
          enrollment_subject.update_attributes! status: CourseSubject::FINISH
        end
        string_all_user_course_subject = users.collect(&:name).*(", ")
        flash[:success] = string_all_user_course_subject
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