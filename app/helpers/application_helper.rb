module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title page_title
    base_title = "Training Management System"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  # Get the correct index for list/table with pagination
  def item_index index
  	current_page = params[:page].present? ? params[:page].to_i - 1 : 0
  	index + 1 + current_page * Settings.items.per_page
  end
end