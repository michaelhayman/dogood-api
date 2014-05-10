# encoding: UTF-8

module Zoocasa
  module CoreExtensions
    module Comparable
      def at_most(value)
        if self > value
          value
        else
          self
        end
      end

      def at_least(value)
        if self < value
          value
        else
          self
        end
      end
    end
  end
end

