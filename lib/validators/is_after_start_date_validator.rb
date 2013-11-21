class IsAfterStartDateValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
  	if record.start_date && record.end_date
      if record.start_date > record.end_date
      	record.errors[attribute] << "must be after start date"
    	end
    end
  end
end