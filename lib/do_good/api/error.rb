module DoGood
  module Api
    class Error < RuntimeError
      attr_reader :dg_message, :http_error, :dg_error

      def initialize
        @dg_message = "A problem has occured with your request."
        @http_error = 400
        @dg_error = 101
      end
    end

    class ConnectionError < Error; end

    class RecordNotFound < Error
      def initialize
        @dg_message = "Record not found."
        @http_error = 404
        @dg_error = 100
      end
    end

    class ParametersInvalid < Error
      def initialize
        @dg_message = "Parameters are missing or are incorrectly formatted."
        @http_error = 404
        @dg_error = 100
      end
    end

    class Unauthorized < Error
      def initialize
        @dg_message = "Invalid email or password."
        @http_error = 401
        @dg_error = 105
      end
    end

    class RecordNotSaved < Error
      def initialize(message)
        @dg_message = message
        @http_error = 500
        @dg_error = 106
      end
    end

    class TooManyQueries < Error
      def initialize
        @dg_message = "Too many queries man."
        @http_error = 500
        @dg_error = 106
      end
    end
  end
end
