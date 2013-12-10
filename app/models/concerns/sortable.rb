module Sortable
  extend ActiveSupport::Concern
 
  included do
    scope :sort_asc, -> { order('sort_index ASC') }
    scope :sort_desc, -> { order('sort_index DESC') }
  end
end