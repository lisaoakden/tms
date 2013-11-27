class Trainee < ActiveRecord::Base
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

  scope :not_in_active_course, ->{where current_course_id: nil}

  scope :free, -> do 
    where(current_course_id: nil).where.not id: Enrollment.active
  end
  def free?
    self.current_course_id.blank?
  end

  class << self
    def update_coure_id! trainee, course_id
      trainee.update_attribute :current_course_id, course_id
    end
  end
  
  def Trainee.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Trainee.encrypt token
    Digest::SHA1.hexdigest token.to_s
  end

  class << self
    def selected_trainees ids
      self.find ids if ids.present?
    end
  end

  private
  def create_remember_token
    self.remember_token = Trainee.encrypt Trainee.new_remember_token
  end
end