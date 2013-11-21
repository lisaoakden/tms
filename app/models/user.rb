class User < ActiveRecord::Base
  NO_COURSE = 0
  has_secure_password
  belongs_to :current_course, class_name: Course.name
  has_many :enrollment_subjects, through: :enrollments
	has_many :enrollments, dependent: :destroy
  has_many :activities
  has_many :courses, through: :enrollments
  has_many :have_subjects, through: :enrollments, source: :enrollment_subjects
  has_one :current_enrollment, class_name: Enrollment.name,
    foreign_key: :course_id, primary_key: :current_course_id

	before_save {self.email = email.downcase}
  before_create :create_remember_token
  validates :name,  presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, 
    uniqueness: {case_sensitive: false}

  validates :password, length: {minimum: 6}
  validates :current_course_id, presence: true

  scope :choose_user_in_course, ->current_course_id do 
    where current_course_id: current_course_id
  end
  scope :choose_user_no_course, ->current_course_id do 
    where.not current_course_id: current_course_id
  end
  
  scope :choose_user_not_in_course, ->ids, course_id do 
    where.not(id: ids).where current_course_id: course_id
  end

  def unassigned?
    self.current_course_id == NO_COURSE
  end

  class << self
    def update_coure_id! user, course_id
      user.update_attribute :current_course_id, course_id
    end
  end
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt token
    Digest::SHA1.hexdigest token.to_s
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt User.new_remember_token
  end
end