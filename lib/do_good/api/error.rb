module DoGood
  module Api
    class Error < RuntimeError
      attr_reader :message, :http_error, :dg_error

      def initialize
        @message = "A problem has occured with your request."
        @http_error = :bad_request
        @dg_error = 101
      end
    end

    class ConnectionError < Error; end

    class RecordNotFound < Error
      def initialize
        @message = "Record not found."
        @http_error = :not_found
        @dg_error = 100
      end
    end

    class ParametersInvalid < Error
      def initialize(msg = nil)
        @message = msg || "Parameters are missing or are incorrectly formatted."
        @http_error = :unprocessable_entity
        @dg_error = 100
      end
    end

    class Unauthorized < Error
      def initialize
        @message = "Invalid email or password."
        @http_error = :unauthorized
        @dg_error = 105
      end
    end

    class RecordNotSaved < Error
      def initialize(msg = nil)
        @message = msg
        @http_error = :internal_server_error
        @dg_error = 106
      end
    end

    class TooManyQueries < Error
      def initialize
        @message = "Over query limit."
        @http_error = :too_many_requests
        @dg_error = 106
      end
    end

    # fold into params invalid
    class Unprocessable < Error
      def initialize(msg = nil)
        @message = msg || "Unprocessable"
        @http_error = :unprocessable_entity
        @dg_error = 106
      end
    end
  end
end
