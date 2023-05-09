# frozen_string_literal: true

module IngvQuake
  # The Resource class serves as a base class for working with resources from the
  # INGV Earthquake web services API. It provides a client to make requests, handle
  # responses, and parse the response data.
  #
  # The Resource class should not be used directly but should be subclassed for
  # specific resources like events.
  class Resource
    attr_reader :client

    # Hash containing error messages for specific HTTP status codes.
    ERROR_MESSAGES = {
      400 => 'Your request was malformed',
      404 => 'No results were found for your request',
      413 => 'Request entity too large',
      429 => 'Your request exceeded the API rate limit',
      500 => 'We were unable to perform the request due to server-side problems',
      503 => 'You have been rate limited, try again in a minute'
    }.freeze

    # Initializes a new Resource instance with a given client.
    #
    # @param client [IngvQuake::Client] The client instance used to make API requests.
    def initialize(client)
      @client = client
    end

    # Sends a GET request to the specified API endpoint to retrieve events and
    # handles the response.
    #
    # @param params [Hash] Optional query parameters for the request.
    # @return [Array] An array of parsed event objects.
    def get_events_request(params: {})
      handle_response client.connection.get('/fdsnws/event/1/query', params)
    end

    private

    # Handles the response from the API by checking for error status codes and
    # raising an error if necessary. If the response is successful, it calls
    # parse_response to parse the response data.
    #
    # @param response [Faraday::Response] The response object from the API request.
    # @return [Array] An array of parsed event objects.
    # @raise [Error] If the response contains an error status code.
    def handle_response(response)
      raise Error, "#{ERROR_MESSAGES[response.status]} #{response.body}" if ERROR_MESSAGES.key?(response.status)

      parse_response(response)
    end

    # Parses the response data depending on the content type. If the content type is
    # 'application/xml', it calls the FullInfoEventParser; otherwise, it calls the
    # BasicInfoEventParser.
    #
    # @param response [Faraday::Response] The response object from the API request.
    # @return [Array] An array of parsed event objects.
    def parse_response(response)
      return [] if response.body.empty?

      xml_content_type = response.headers['Content-Type'].include?('application/xml')
      xml_content_type ? FullInfoEventParser.call(response.body) : BasicInfoEventParser.call(response.body)
    end
  end
end
