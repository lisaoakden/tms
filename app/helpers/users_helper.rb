module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for user, options = { size: 50 }
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def user_name user_id
  	@user = User.find user_id
  end

  def course_name course_id
  	@course = Course.find course_id
  end

  def task_name task_id
    @task = EnrollmentTask.find task_id
  end

  def subject_name subject_id
    @subject = EnrollmentSubject.find subject_id
  end
end