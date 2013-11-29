class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :conclusions
  has_many :enrollment_subjects

  accepts_nested_attributes_for :enrollment_subjects
  
  scope :active, ->{where active_flag: Settings.flag.active}

  def activated?
    self.status == Settings.status.started
  end
end