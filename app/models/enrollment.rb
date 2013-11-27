class Enrollment < ActiveRecord::Base
  belongs_to :trainee
  belongs_to :course
  has_many :conclusions
  has_many :enrollment_subjects

  accepts_nested_attributes_for :enrollment_subjects
  
  scope :active, -> do 
    where active_flag: Settings.flag.active, status:Settings.status.new
  end
  def activated?
    self.status == Settings.status.started
  end

  def inactivated?
    not activated?
  end
end