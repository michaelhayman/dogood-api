# encoding: UTF-8

module Dapi::CallbackHelper
  extend ActiveSupport::Concern

  D_STATUS = Dapi::Constants::STATUS_CODES
  D_EXTENDED_STATUS = Dapi::Constants::STATUS_CODES

  included do
    self.class_eval do
      include_private PrivateInstanceMethods
      include_private ActionView::Helpers::JavaScriptHelper
    end
  end

  module PrivateInstanceMethods
    # Sets up a response for a DAPI server-side callback. The action
    # will be rendered immediately and will be rendered something like this:
    #
    #   "#{params[options[:callback_name]]} && #{params[options[:callback_name]]}(#{output});"
    #
    # Which would in turn look something like this from the Javascript
    # side:
    #
    #   __callback_0__ && __callback_0__({ "this": "is", "some": "json" });
    #
    # Options:
    #
    # * :default_format - used when params[:format] is unset. Defaults
    #   to 'json'.
    # * :callback_name - the name of the callback parameter found in
    #   the URL. Defaults to :ZCB.
    def dapi_callback_wrapper_new_style(*args)
      options = {
        :controller => controller_name,
        :action => action_name,
        :status => :ok,
        :ignore_nil => true
      }.merge(args.extract_options!)

      status = if options[:status].present?
        D_STATUS[options[:status]] || options[:status].to_s
      else
        D_STATUS[:ok]
      end

      prc = proc { |json|
        json.DAPI do
          json.controller options[:controller].camelize
          json.action options[:action]
          json.status status

          json.response do |json|
            json.ignore_nil! if options[:ignore_nil]
            json.status status

            if block_given?
              yield json
            end
          end

          if options[:ga]
            json.ga options[:ga].deep_camelize_keys(:lower)
          end
        end
      }

      if args.length > 0
        prc.call(args.first)
      else
        Jbuilder.encode(&prc)
      end
    end
  end
end

