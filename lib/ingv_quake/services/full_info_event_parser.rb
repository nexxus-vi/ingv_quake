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

      events.map { |data| create_full_info_event(data) }
    end

    private

    def create_full_info_event(data)
      magnitude = data.dig('magnitude', 'mag', 'value').to_f

      if magnitude >= 3.0
        event_id = data['publicID']
        kinds = %w[intensity pga pgv]
        intensity_map, pga_map, pgv_map = generate_urls(event_id, kinds)

        shake_map = {
          intensity_map: intensity_map,
          pga_map: pga_map,
          pgv_map: pgv_map
        }.transform_keys(&:to_s)
      end

      FullInfoEvent.new(data: data, shake_map: shake_map)
    end

    def generate_urls(event_id, kinds)
      url_prefix = "http://shakemap.rm.ingv.it/shake4/data/#{event_id}/current/products/"
      kinds.map { |kind| "#{url_prefix}#{kind}" }
    end
  end
end
