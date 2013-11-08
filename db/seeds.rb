user_list = [ 
	{ name: "MuiNV", email: "mui@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 1},
	{ name: "OanhLK", email: "oanh@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 1 },
	{ name: "KhanhCD", email: "khanh@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 1 },
	{ name: "QuanNT", email: "quan@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 2 },
	{ name: "VuLD", email: "vu@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 2 },
	{ name: "CongHD", email: "cong@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 2 },
	{ name: "TamDT", email: "tam@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 3 },
	{ name: "DungDT", email: "dung@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 3 },
	{ name: "ChuyenVV", email: "chuyen@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 4 },
	{ name: "HoangTN", email: "hoang@framgia.com", password: "123456", password_confirmation: "123456", current_course_id: 4 }
]
user_list.each do |user|
  User.create! user
end

course_list = [
	{ name: "TrainingProject0110", start_date: "01-10-2013", end_date: "01-12-2013" },
	{ name: "TrainingProject0710", start_date: "07-10-2013", end_date: "07-12-2013" },
	{ name: "TrainingProject2010", start_date: "20-10-2013", end_date: "20-12-2013" },
	{ name: "TrainingProject2710", start_date: "27-10-2013", end_date: "27-12-2013" },
]

course_list.each do |course|
  Course.create! course
end

subject_list = [
	{ name: "Ruby on Rails", description: "abc123", duration: 12},
	{ name: "Git", description: "abc123", duration: 1},
	{ name: "MySQL", description: "abc123", duration: 5},
	{ name: "PHP", description: "abc123", duration: 12}
]

subject_list.each do |subject|
	Subject.create! subject
end
s1 = Subject.find(1)
	Task.create!(subject_id: s1.id, name: "demo app", description: "abc1234566")
	Task.create!(subject_id: s1.id, name: "test Ror", description: "abc1234566")
	

(1..11).each do |no|
	Task.create!(subject_id: s1.id, name: "chapter#{no}", description: "abc1234566")
end


s2 = Subject.find(2)
	Task.create!(subject_id: s2.id, name: "read chapter", description: "abc1234566")
	Task.create!(subject_id: s2.id, name: "Git lecture", description: "abc1234566")
	Task.create!(subject_id: s2.id, name: "final test", description: "abc1234566")

s3 = Subject.find(3)
	Task.create!(subject_id: s3.id, name: "first MySQL test", description: "abc1234566")
	Task.create!(subject_id: s3.id, name: "read chapter", description: "abc1234566")
	Task.create!(subject_id: s3.id, name: "MySQL lecture", description: "abc1234566")
	Task.create!(subject_id: s3.id, name: "final MySQL test", description: "abc1234566")

s4 = Subject.find(4)
	Task.create!(subject_id: s4.id, name: "first PHP test", description: "abc1234566")
	Task.create!(subject_id: s4.id, name: "read chapter", description: "abc1234566")
	Task.create!(subject_id: s4.id, name: "PHP lecture", description: "abc1234566")
	Task.create!(subject_id: s4.id, name: "final PHP test", description: "abc1234566")
u = Array.new(11) 
(1..10).each do |num|
	u[num] = User.find num
end

(1..3).each do |num1|
	Enrollment.create! user_id: u[num1].id, course_id: 1, joined_date: "01-10-2013", status: 0
end

(4..6).each do |num2|
	Enrollment.create! user_id: u[num2].id, course_id: 2, joined_date: "07-10-2013", status: 0
end

(7..8).each do |num3|
	Enrollment.create! user_id: u[num3].id, course_id: 3, joined_date: "20-10-2013", status: 0
end

(9..10).each do |num4|
	Enrollment.create! user_id: u[num4].id, course_id: 4, joined_date: "27-10-2013", status: 0
end

e = Array.new(11) 
(1..10).each do |num|
	e[num] = Enrollment.find num
end

(1..10).each do |num|
	Conclusion.create! enrollment_id: e[num].id, content: "fail", comment: "anfdfdf dfdfd g"
end

c = Array.new(5) 
(1..4).each do |num|
	c[num] = Course.find num
end

(1..3).each do |num|
	CourseSubject.create! course_id: c[num].id, subject_id: s1.id
	CourseSubject.create! course_id: c[num].id, subject_id: s2.id
	CourseSubject.create! course_id: c[num].id, subject_id: s3.id
	CourseSubject.create! course_id: c[num].id, subject_id: s4.id
end
	CourseSubject.create! course_id: c[4].id, subject_id: s1.id
	CourseSubject.create! course_id: c[4].id, subject_id: s3.id
	CourseSubject.create! course_id: c[4].id, subject_id: s4.id

course_subjects = CourseSubject.all
course_subjects.each { |cs|
	subject = Subject.find cs.subject_id
	subject.tasks.each { |task|
		CourseSubjectTask.create! course_subject_id: cs.id, subject_id: subject.id, task_id: task.id
	}
}

enrollments = Enrollment.all
enrollments.each { |el|
	subjects = el.course.subjects
	subjects.each { |sj|
		EnrollmentSubject.create! enrollment_id: el.id, subject_id: sj.id, status: "new", start_date: "01-10-2013"
	}
}

enrollment_subjects = EnrollmentSubject.all
enrollment_subjects.each { |es|
	course_subject = es.enrollment.course.course_subjects.find_by es.subject_id
	tasks = course_subject.course_subject_tasks
	tasks.each { |t|
		EnrollmentTask.create! enrollment_subject_id: es.id, subject_id: es.subject_id, task_id: t.task_id, status: "new"
	}
}