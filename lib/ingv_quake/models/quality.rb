# frozen_string_literal: true

module IngvQuake
  # The Quality class represents the metadata related to the quality details of an event record
  #
  # @attr_reader azimuthal_gap [Integer] Largest azimuthal gap in station distribution as seen from epicenter.
  # @attr_reader associated_phase_count [Integer] Number of associated phases, regardless of their use for origin computation.
  # @attr_reader used_phase_count [Integer] Number of defining phases, i. e., phase observations that were actually used for computing
  #   the origin. Note that there may be more than one defining phase per station.
  # @attr_reader standard_error [Float] RMS of the travel time residuals of the arrivals used for the origin computation. Unit: s.
  # @attr_reader minimum_distance [Float] Epicentral distance of station closest to the epicenter.
  # @attr_reader maximum_distance [Float] Epicentral distance of station farthest from the epicenter.
  # @attr_reader associated_station_count [Integer] Number of stations at which the event was observed.
  # @attr_reader used_station_count [Integer] Number of stations from which data was used for origin computation.
  class Quality
    attr_reader :azimuthal_gap, :associated_phase_count, :used_phase_count, :standard_error,
                :minimum_distance, :maximum_distance, :associated_station_count, :used_station_count

    # Initializes a new Quality instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the quality of an event.
    def initialize(data)
      @associated_phase_count = data.fetch('associatedPhaseCount', nil)&.to_i
      @associated_station_count = data.fetch('associatedStationCount', nil)&.to_i
      @azimuthal_gap = data.fetch('azimuthalGap', nil)&.to_i
      @maximum_distance = data.fetch('maximumDistance', nil)&.to_f
      @minimum_distance = data.fetch('minimumDistance', nil)&.to_f
      @standard_error = data.fetch('standardError', nil)&.to_f
      @used_phase_count = data.fetch('usedPhaseCount', nil)&.to_i
      @used_station_count = data.fetch('usedStationCount', nil)&.to_i
    end
  end
end
