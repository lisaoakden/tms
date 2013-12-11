class Subject < ActiveRecord::Base
  include Active

  has_many :course_subjects
  has_many :enrollment_subjects
  has_many :tasks,:dependent => :destroy

  accepts_nested_attributes_for :tasks

  validates :name, presence: { message: "Subject name can't be blank" }
  validates :duration, numericality: { only_integer: true, message: "Subject duration is not a number" } 
end