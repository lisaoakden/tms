module Active
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(active_flag: Settings.flag.active) }
    scope :inactive, -> { where(active_flag: Settings.flag.inactive) }
  end
end