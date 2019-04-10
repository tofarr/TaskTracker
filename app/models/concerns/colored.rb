require 'colors'

module Colored extend ActiveSupport::Concern

  included do
    after_initialize :set_default_color
  end

  def set_default_color
    self.color = Colors.rand_color if has_attribute?(:color) && !self.color
  end
end
