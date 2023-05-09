# frozen_string_literal: true

module IngvQuake
  # The Magnitude class represents the metadata related to the magnitude of an event record
  #
  # @attr_reader station_count [Integer] The number of stations that contributed to the magnitude calculation.
  # @attr_reader origin_id [String] The origin ID of the magnitude.
  # @attr_reader type [String] The type of the magnitude.
  # @attr_reader value [Float] The value of the magnitude.
  # @attr_reader uncertainty [Float] The uncertainty of the magnitude value.
  # @attr_reader method_id [String] The method ID used to calculate the magnitude.
  # @attr_reader creation_info [CreationInfo] The creation info of the magnitude.
  # @attr_reader public_id [String] The public ID of the magnitude.
  class Magnitude
    attr_reader :station_count, :origin_id, :type, :value, :uncertainty, :method_id, :creation_info,
                :public_id

    # Initializes a new Magnitude instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the magnitude of an event.
    def initialize(data)
      @station_count = data.fetch('stationCount', nil)&.to_i
      @origin_id = data.fetch('originID', nil)
      @type = data.fetch('type', nil)
      @value = data.dig('mag', 'value')&.to_f
      @uncertainty = data.dig('mag', 'uncertainty')&.to_f
      @method_id = data.fetch('methodID', nil)
      @creation_info = data.fetch('creationInfo', nil)&.then { |creation_info_data| CreationInfo.new(creation_info_data) }
      @public_id = data.fetch('publicID', nil)
    end
  end
end
