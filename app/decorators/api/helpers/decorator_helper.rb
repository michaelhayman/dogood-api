# encoding: UTF-8

module Api::Helpers::DecoratorHelper
  extend ActiveSupport::Concern

  included do
    extend Memoist

    delegate_all

    memoize :output_attributes
  end

  private
    def output_attributes
      if context[:output_attributes].present?
        Array.wrap(context[:output_attributes]).each_with_object(HashWithIndifferentAccess.new) do |attr, memo|
          memo[attr] = true
        end
      end
    end

    def output_optional_attribute?(name)
      output_attributes.blank? ||
        !!output_attributes.try(:[], name)
    end
end

