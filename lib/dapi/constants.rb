# encoding: UTF-8

module Dapi::Constants
  EXTENDED_STATUS_CODES = {
    :bad_object        => 710,
    :missing_object        => 704
  }.freeze

  STATUS_CODES = {
    :bad_key              => 'BAD_KEY',
    :bad_object           => 500,
    :error                => 'ERROR',
    :gateway_timeout      => 'GATEWAY_TIMEOUT',
    :invalid_request      => 'INVALID_REQUEST',
    :no_user              => 'NO_USER',
    :ok                   => 'OK',
    :over_query_limit     => 500,
    :request_denied       => 'REQUEST_DENIED',
    :server_error         => 'SERVER_ERROR',
    :unknown_error        => 'UNKNOWN_ERROR',
    :unauthorized         => 401,
    :unprocessable_entity => 422,
    :zero_results         => 'ZERO_RESULTS'
  }.deep_freeze
end
