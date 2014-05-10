# encoding: UTF-8

module Zoocasa
  module CoreExtensions
    module SimpleInspect
      def inspect
        "#<#{self.class.name}: ...>"
      end
    end
  end
end

