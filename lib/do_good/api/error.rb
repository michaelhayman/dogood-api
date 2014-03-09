module DoGood
  module Api
    class Error < RuntimeError
      attr_reader :message, :http_error

      def initialize(msg = nil)
        @message = msg || "A problem has occured with your request."
        @http_error = :bad_request
      end
    end

    class ConnectionError < Error; end

    class RecordNotFound < Error
      def initialize
        @message = "Record not found."
        @http_error = :not_found
      end
    end

    class ParametersInvalid < Error
      def initialize(msg = nil)
        @message = msg || "Parameters are missing or are incorrectly formatted."
        @http_error = :unprocessable_entity
      end
    end

    class Unauthorized < Error
      def initialize
        @message = "Invalid email or password."
        @http_error = :unauthorized
      end
    end

    class RecordNotSaved < Error
      def initialize(msg = nil)
        @message = msg
        @http_error = :internal_server_error
      end
    end

    class TooManyQueries < Error
      def initialize
        @message = "Over query limit."
        @http_error = :too_many_requests
      end
    end
  end
end
