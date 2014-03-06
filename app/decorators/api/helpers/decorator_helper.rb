module Api::Helpers::DecoratorHelper
  extend ActiveSupport::Concern

  included do
    extend Memoist

    delegate_all
  end
end

