# encoding: UTF-8

module Ruby
  module CoreExtensions
    module Traversable
      # Walk along the Object until you get to the path you're looking for
      # and return it. If at any point we can't find the appropriate key,
      # return nil immediately. A default can be set in the options Hash for
      # an alternate return value on nil.
      def traverse(*args)
        options = args.extract_options!
        ret = args.inject(self) do |memo, obj|
          if memo.respond_to?(:[])
            memo[obj] || break
          else
            memo
          end
        end

        if options[:nil] && ret.nil?
          options[:nil]
        else
          ret
        end
      end
    end
  end
end
