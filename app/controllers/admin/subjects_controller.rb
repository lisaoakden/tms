class Admin::SubjectsController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor

  def index
    @subjects = Subject.all
        .paginate page: params[:page], per_page: Settings.items.per_page
  end

  def show
    @subject = Subject.find params[:id], include: @tasks
  end

  def new
    @subject = Subject.new
  end

  def create
    Subject.transaction do
      @subject = Subject.new subject_params
      if @subject.save
        Task.transaction do
          if params[:tasks].present?
            params[:tasks].each do |t|
              @task = Task.new subject_id: @subject.id, name: t
              render 'new' unless @task.save
            end
          end
        end
        redirect_to admin_subject_url @subject
      else
        render 'new'
      end
    end
  end

  def edit
    @subject = Subject.find params[:id], include: @tasks
  end

  def update
    @subject = Subject.find params[:id], include: @tasks
    Subject.transaction do
      if @subject.update_attributes subject_params
        Task.transaction do
          @subject.tasks.destroy_all if @subject.tasks.any?
          if params[:tasks].present?
            params[:tasks].each do |t|
              @task = Task.new subject_id: @subject.id, name: t
              render 'edit' unless @task.save
            end
          end
        end
        redirect_to admin_subject_url @subject
      else
        render 'edit'
      end
    end
  end

  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Subject deleted."
    redirect_to admin_subjects_url
  end

  private
  def subject_params
    params.require(:subject).permit :name, :duration, :description
  end
end