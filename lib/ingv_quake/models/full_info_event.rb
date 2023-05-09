# frozen_string_literal: true

module IngvQuake
  # The FullInfoEvent class describes a seismic event which does not necessarily need to be a tectonic earthquake.
  # An event is usually associated with one or more origins, which contain information about focal time and geographical
  # location of the event.
  #
  # @attr_reader creation_info [CreationInfo] The creation info of the event.
  # @attr_reader focal_mechanism [FocalMechanism] The focal mechanism of the event.
  # @attr_reader location [String] The location of the event.
  # @attr_reader location_description_type [String] The location of the event. Can be one of: <b>'felt report',
  #  'Flinn-Engdahl region', 'local time', 'tectonic summary', 'nearest cities', 'earthquake name', 'region name'</b>.
  # @attr_reader magnitude [Magnitude] Reference to an associated Magnitude.
  # @attr_reader origin [Origin] Reference to an associated Origin.
  # @attr_reader preferred_focal_mechanism_id [String] Refers to the publicID of the preferred Focal Mechanism object.
  # @attr_reader preferred_magnitude_id [String] Refers to the publicID of the preferred Magnitude object.
  # @attr_reader preferred_origin_id [String] Refers to the publicID of the preferred Origin object.
  # @attr_reader public_id [String] Resource identifier of Event.
  # @attr_reader type [String] The type of the event. Can be one of: <b>'not existing', 'not reported', 'earthquake',
  #   'anthropogenic event', 'collapse', 'cavity collapse', 'mine collapse', 'building collapse', 'explosion',
  #   'accidental explosion', 'chemical explosion', 'controlled explosion', 'experimental explosion',
  #   'industrial explosion', 'mining explosion', 'quarry blast', 'road cut', 'blasting levee', 'nuclear explosion',
  #   'induced or triggered event', 'rock burst', 'reservoir loading', 'fluid injection', 'fluid extraction', 'crash',
  #   'plane crash', 'train crash', 'boat crash', 'other event', 'atmospheric event', 'sonic boom', 'sonic blast',
  #   'acoustic noise', 'thunder', 'avalanche', 'snow avalanche', 'debris avalanche', 'hydroacoustic event',
  #   'ice quake', 'slide', 'landslide', 'rockslide', 'meteorite', 'volcanic eruption'</b>.
  class FullInfoEvent
    attr_reader :creation_info, :focal_mechanism, :location, :location_description_type, :magnitude, :origin,
                :preferred_focal_mechanism_id, :preferred_magnitude_id, :preferred_origin_id, :public_id, :type

    # Initializes a new FullInfoEvent instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about an event.
    def initialize(data)
      @creation_info = data.fetch('creationInfo', nil)&.then { |creation_info_data| CreationInfo.new(creation_info_data) }
      @focal_mechanism = data.fetch('focalMechanism', nil)&.then { |focal_mechanism_data| FocalMechanism.new(focal_mechanism_data) }
      @location = data.dig('description', 'text')
      @location_description_type = data.dig('description', 'type')
      @magnitude = data.fetch('magnitude', nil)&.then { |magnitude_data| Magnitude.new(magnitude_data) }
      @origin = data.fetch('origin', nil)&.then { |origin_data| Origin.new(origin_data) }
      @preferred_focal_mechanism_id = data.fetch('preferredFocalMechanismID', nil)
      @preferred_magnitude_id = data.fetch('preferredMagnitudeID', nil)
      @preferred_origin_id = data.fetch('preferredOriginID', nil)
      @public_id = data.fetch('publicID', nil)
      @type = data.fetch('type', nil)
    end
  end
end
