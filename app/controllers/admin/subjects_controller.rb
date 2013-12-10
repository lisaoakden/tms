class Admin::SubjectsController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor

  def index
    @subjects = Subject.active
        .paginate page: params[:page], per_page: Settings.items.per_page
  end

  def show
    @subject = Subject.active.find params[:id]
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      redirect_to admin_subject_url @subject
    else
      render 'new'
    end
  end

  def edit
    @subject = Subject.active.find params[:id]
  end

  def update
    @subject = Subject.active.find params[:id]
    if @subject.update_attributes subject_params
      redirect_to admin_subject_url @subject
    else
      render 'edit'
    end
  end

  def destroy
    subject = Subject.active.find params[:id]
    subject.update_attribute :active_flag, Settings.flag.inactive if subject.present?
    flash[:success] = "Subject deleted."
    redirect_to admin_subjects_url
  end

  private
  def subject_params
    tasks_params = Hash.new()
    params[:tasks].each_with_index do |task, index|
      tasks_params[index] = task
    end
    params.require(:subject).permit(:name, :duration, :description).tap do |whitelisted|
      whitelisted[:tasks_attributes] = tasks_params
    end
  end
end