class Enrollment < ActiveRecord::Base
  include Active
  
  belongs_to :trainee
  belongs_to :course
  has_many :conclusions
  has_many :enrollment_subjects

  accepts_nested_attributes_for :enrollment_subjects
  
  scope :new, -> { where status: Settings.status.new }
  
  def activated?
    self.status == Settings.status.started
  end

  def inactivated?
    not activated?
  end
end