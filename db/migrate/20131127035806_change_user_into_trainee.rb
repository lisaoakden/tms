class ChangeUserIntoTrainee < ActiveRecord::Migration
  def change
  	rename_table :users, :trainees

  	rename_column :activities, :user_id, :trainee_id
  	rename_column :enrollments, :user_id, :trainee_id
  	rename_column :enrollment_subjects, :user_id, :trainee_id
  end
end
