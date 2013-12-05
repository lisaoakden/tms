class Subject < ActiveRecord::Base
  has_many :course_subjects
  has_many :enrollment_subjects
  has_many :tasks, ->{where active_flag: Settings.flag.active},:dependent => :destroy

  validates :name, presence: { message: "Subject name can't be blank" }
  validates :duration, numericality: { only_integer: true, message: "Subject duration is not a number" } 
end