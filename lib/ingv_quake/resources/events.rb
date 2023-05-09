# frozen_string_literal: true

require 'geocoder'

module IngvQuake
  # The EventResource class is a subclass of the Resource class, providing
  # additional methods for querying earthquake events with specific filters.
  class EventResource < Resource
    # Queries events based on the provided parameters.

    # @example Search for BasicInfo events with max magnitude 5 and min depth 3
    #   client = IngvQuake::Client.new
    #   events = client.get_events
    #   events.where(format: 'text', maxmag: 5, mindepth: 3)
    #
    # @param params [Hash] options to be used in request
    # @option params [Integer] :originid Origin ID of the event.
    # @option params [Integer] :magnitudeid Magnitude ID of the event.
    # @option params [String] :starttime Query events starting from this date: <b>'2023-04-01T15:06:38'</b>.
    # @option params [String] :endtime Query events until this date: <b>'2023-04-01T15:06:38'</b>.
    # @option params [String] :address The address of the central latitude point for a radial search: 'Roma, via condotti 1'. <b>This is a custom param, not available on the INGV api</b>.
    # @option params [Float] :minlat Specify southern boundary for search (in WGS84): <b>45.492599</b>.
    # @option params [Float] :maxlat Specify northern boundary for search (in WGS84): <b>45.492599</b>.
    # @option params [Float] :minlon Specify western boundary for search (in WGS84): <b>9.19289</b>.
    # @option params [Float] :maxlon Specify eastern boundary for search (in WGS84): <b>9.19289</b>.
    # @option params [Float] :lat Specify the central latitude point for a radial search (in WGS84): <b>45.492599</b>.
    # @option params [Float] :lon Specify the central longitude point for a radial search (in WGS84): <b>9.19289</b>.
    # @option params [Float] :minradius Specify minimum distance from the geographic point defined by latitude and longitude (in Degrees).
    # @option params [Float] :maxradius Specify maximum distance from the geographic point defined by latitude and longitude (in Degrees).
    # @option params [Float] :minradiuskm Specify minimum distance from the geographic point defined by latitude and longitude. Kilometers. This is an INGV extension to the FDSN specification.
    # @option params [Float] :maxradiuskm Specify maximum distance from the geographic point defined by latitude and longitude. Kilometers. This is an INGV extension to the FDSN specification.
    # @option params [Float] :minmag Limit to events with a magnitude larger than or equal to the specified minimum.
    # @option params [Float] :maxmag Limit to events with a magnitude smaller than or equal to the specified maximum.
    # @option params [Float] :mindepth Specify minimum depth (kilometers), values increase positively with depth.
    # @option params [Float] :maxdepth Specify maximum depth (kilometers), values increase positively with depth.
    # @option params [String] :orderby The sorting order for the results. Possible values: <b>'time', 'time-asc', 'magnitude', 'magnitude-asc'</b>. Default: 'time'.
    # @option params [Integer] :limit Limit the results to the specified number of events.
    # @option params [Integer] :offset Return results starting at the event count specified.
    # @option params [String] :updatedafter Limit to events updated after the specified time (useful for synchronizing events).
    # @option params [String] :format Specify output format. Possible values: <b>'text', 'xml'. Default: 'text'</b>.
    # @option params [Integer] :eventid Retrieve an event based on the unique INGV event id.
    # @option params [Boolean] :includeallorigins Is used to retrieve all origins associated with each event.
    # @option params [Boolean] :includeallmagnitudes Is used to retrieve all magnitudes associated with each event.
    # @option params [Boolean] :includeallstationsmagnitudes Is used to retrieve all stations magnitudes associated with each hypocenter.
    # @option params [Boolean] :includearrivals Is used to retrieve any associated phase arrival information for each event.
    # @return [Array] An array of parsed event objects.
    def where(params = {})
      send_request(params)
    end

    # Queries events that occurred between the specified start and end times.
    #
    # @param starttime [DateTime] The start time for the query.
    # @param endtime [DateTime] The end time for the query.
    # @param params [Hash] (optional) Additional query parameters (see #where).
    # @return [Array] An array of parsed event objects.
    def between_dates(starttime:, endtime:, **params)
      send_request({ starttime: format_datetime(starttime), endtime: format_datetime(endtime), **params })
    end

    # Queries events that occurred after the specified start time.
    #
    # @param starttime [DateTime] The start time for the query.
    # @param params [Hash] (optional) Additional query parameters (see #where).
    # @return [Array] An array of parsed event objects.
    def starting_from(starttime:, **params)
      send_request({ starttime: format_datetime(starttime), **params })
    end

    # Queries events with magnitudes between the specified minimum and maximum values.
    #
    # @param minmag [Integer, Float] The minimum magnitude for the query.
    # @param maxmag [Float] The maximum magnitude for the query.
    # @param params [Hash] (optional) Additional query parameters (see #where).
    # @return [Array] An array of parsed event objects.
    def between_magnitude(minmag:, maxmag:, **params)
      send_request({ minmag: minmag, maxmag: maxmag, **params })
    end

    # Queries events that occurred within the last hour.
    #
    # @param params [Hash] (optional) Additional query parameters (see #where).
    # @return [Array] An array of parsed event objects.
    def within_last_hour(**params)
      an_hour_ago = DateTime.now - Rational(1, 24)
      send_request({ starttime: format_datetime(an_hour_ago), **params })
    end

    # Queries events that occurred within the last day.
    #
    # @param params [Hash] (optional) Additional query parameters (see #where).
    # @return [Array] An array of parsed event objects.
    def within_last_day(**params)
      a_day_ago = DateTime.now.prev_day
      send_request({ starttime: format_datetime(a_day_ago), **params })
    end

    # Queries events that occurred within the last week.
    #
    # @param params [Hash] (optional) Additional query parameters (see #where).
    # @return [Array] An array of parsed event objects.
    def within_last_week(**params)
      a_week_ago = (DateTime.now - 7)
      send_request({ starttime: format_datetime(a_week_ago), **params })
    end

    # Queries events that occurred within the last month.
    #
    # @param params [Hash] (optional) Additional query parameters (see #where).
    # @return [Array] An array of parsed event objects.
    def within_last_month(**params)
      a_month_ago = DateTime.now.prev_month
      send_request({ starttime: format_datetime(a_month_ago), **params })
    end

    private

    # Sends a request with the specified parameters.
    #
    # @param params [Hash] Query parameters.
    # @return [Array] An array of parsed event objects.
    def send_request(params)
      check_radius(params) if boundaries_radial(params)
      address_to_coordinates(params) if params[:address]

      get_events_request(params: { **params })
    end

    # Determines if radial boundary parameters are provided.
    #
    # @param params [Hash] Query parameters.
    # @return [Boolean] True if radial boundary parameters are provided, false otherwise.
    def boundaries_radial(params)
      params[:address] || (params[:lat] && params[:lon])
    end

    # Checks if the radius parameters are provided when searching events near a location.
    #
    # @param params [Hash] Query parameters.
    # @raise [ParamMissingError] If neither maxradiuskm nor maxradius are provided.
    def check_radius(params)
      return if params[:maxradiuskm] || params[:maxradius]

      raise ParamMissingError, 'When searching events near a location, you must provide \'maxradiuskm\' or \'maxradius\' (in degrees)'
    end

    # Formats the input datetime object as an ISO 8601 string.
    #
    # @param datetime [DateTime, Date, Time] The datetime object to format.
    # @return [String] The formatted datetime string.
    def format_datetime(datetime)
      return datetime unless datetime.is_a? DateTime || datetime.is_a?(Date) || datetime.is_a?(Time)

      datetime.strftime('%Y-%m-%dT%H:%M:%S')
    end

    # Converts an address string to latitude and longitude coordinates.
    #
    # @param params [Hash] Query parameters containing the address key.
    # @raise [AddressNotFoundError] If no results are found for the address.
    def address_to_coordinates(params)
      places = Geocoder.search(params[:address])

      raise AddressNotFoundError, 'No results were found for your request. Please check your input' if places.empty?

      lat = places.first.coordinates[0]
      lon = places.first.coordinates[1]
      params[:lat] = lat
      params[:lon] = lon
    end
  end
end
