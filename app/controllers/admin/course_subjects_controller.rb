class Admin::CourseSubjectsController < ApplicationController
  before_action :correct_supervisor

  def update
    @course_subject = CourseSubject.find params[:id]
    users = EnrollmentSubject.users_not_finish_subject params[:course_id],
      @course_subject.subject_id
    @course = current_supervisor.courses.find params[:course_id]
    if @course_subject.unfinished?
      @course_subject.update_attributes! status: Settings.status.finished
      if users.present?
        users.each do |user|
          enrollment_subject = user.current_enrollment.enrollment_subjects
            .find_by subject_id: @course_subject.subject_id
          enrollment_subject.update_attributes! status: Settings.status.finished
        end
        string_all_user_course_subject = users.collect(&:name).*(", ")
        flash[:success] = string_all_user_course_subject
      end
    end
    redirect_to admin_supervisor_course_path current_supervisor, @course
  end

  private
  def correct_supervisor
    supervisor = Supervisor.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end 
end