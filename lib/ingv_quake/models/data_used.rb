# frozen_string_literal: true

module IngvQuake
  # The DataUsed class represents the data used for the moment tensor calculation.
  # It contains information about the type of waveform data, station count,
  # component count, and the shortest and longest periods present in the data.
  #
  # @attr_reader wave_type [String] The type of waveform data used for the moment tensor calculation.
  #   Can be on of: <b>'P waves', 'body waves', 'surface waves', 'mantle waves', 'combined', 'unknown'</b>.
  # @attr_reader station_count [Integer] The number of stations that have contributed data of the type given in wave_type.
  # @attr_reader component_count [Integer] The number of data components of the type given in wave_type.
  # @attr_reader shortest_period [Float] The shortest period present in the data. Unit: s
  # @attr_reader longest_period [Float] The longest period present in the data. Unit: s
  class DataUsed
    attr_reader :wave_type, :station_count, :component_count, :shortest_period, :longest_period

    # Initializes a new DataUsed instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the data used for a moment-tensor inversion.
    def initialize(data)
      @wave_type = data.fetch('waveType', nil)
      @station_count = data.fetch('stationCount', nil)&.to_i
      @component_count = data.fetch('componentCount', nil)&.to_i
      @shortest_period = data.fetch('shortestPeriod', nil)&.to_f
      @longest_period = data.fetch('longestPeriod', nil)&.to_f
    end
  end
end
