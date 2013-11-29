class User < ActiveRecord::Base
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

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, 
    uniqueness: {case_sensitive: false}
  validates :name,  presence: true, length: {maximum: 50}
  validates :password, length: {minimum: 6}

  scope :free, ->{where current_course_id: nil}

  def free?
    self.current_course_id.blank?
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