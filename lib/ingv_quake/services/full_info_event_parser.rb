# frozen_string_literal: true

module IngvQuake
  # The FullInfoEventParser class is responsible for parsing response data containing
  # full information about earthquake events. It inherits from the ApplicationService
  # base class.
  class FullInfoEventParser < ApplicationService
    attr_reader :response

    # Initializes a new FullInfoEventParser instance with the response data.
    #
    # @param response [Hash] The response data to be parsed.
    def initialize(response)
      @response = response
    end

    # Parses the response data and creates an array of FullInfoEvent objects.
    #
    # @return [Array<FullInfoEvent>] An array of FullInfoEvent objects.
    def call
      events = response.dig('quakeml', 'eventParameters', 'event') || []
      events = [events] if events.is_a? Hash

      events.map { |data| FullInfoEvent.new(data) }
    end
  end
end
