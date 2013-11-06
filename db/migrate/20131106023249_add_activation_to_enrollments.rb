class AddActivationToEnrollments < ActiveRecord::Migration
  def change
  	add_column :enrollments, :activation, :boolean, default: false
  end
end
