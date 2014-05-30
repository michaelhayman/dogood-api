##
# Mixin for any model object that can be reported.

module DoGood::Reportable
  extend ActiveSupport::Concern

  module ClassMethods
    def reportable!
      self.class_eval do
        has_one :report,
          as: :reportable,
          dependent: :destroy
      end
    end
  end
end

