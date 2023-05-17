# frozen_string_literal: true

module IngvQuake
  # The BasicInfoEventParser class is responsible for parsing response data containing
  # basic information about earthquake events. It inherits from the ApplicationService
  # base class.
  class BasicInfoEventParser < ApplicationService
    attr_reader :response

    # Initializes a new BasicInfoEventParser instance with the response data.
    #
    # @param response [String] The response data to be parsed.
    def initialize(response)
      @response = response
    end

    # Parses the response data and creates an array of BasicInfoEvent objects.
    #
    # @return [Array<BasicInfoEvent>] An array of BasicInfoEvent objects.
    def call
      @response.lines.drop(1).map do |line|
        event_data = line.strip.split('|')
        attributes = {
          event_id: event_data[0],
          time: event_data[1],
          latitude: event_data[2],
          longitude: event_data[3],
          depth_km: event_data[4],
          author: event_data[5],
          catalog: event_data[6],
          contributor: event_data[7],
          contributor_id: event_data[8],
          mag_type: event_data[9],
          magnitude: event_data[10],
          mag_author: event_data[11],
          location: event_data[12],
          type: event_data[13]
        }

        magnitude = attributes[:magnitude].to_f

        if magnitude >= 3.0
          event_id = attributes[:event_id]

          url_prefix = "http://shakemap.rm.ingv.it/shake4/data/#{event_id}/current/products/"
          attributes[:intensity_map] = "#{url_prefix}intensity.jpg"
          attributes[:pga_map] = "#{url_prefix}pga.jpg"
          attributes[:pgv_map] = "#{url_prefix}pgv.jpg"
        end

        BasicInfoEvent.new(**attributes)
      end
    end
  end
end
