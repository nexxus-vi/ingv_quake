# frozen_string_literal: true

module IngvQuake
  # This class represents the focal time and geographical location of an earthquake hypocenter, as well as additional
  # meta-information
  #
  # @attr_reader evaluation_mode [String] Evaluation mode of Origin. Can be on of: <b>'manual' or 'automated'</b>.
  # @attr_reader type [String] Describes the Origin type. Can be on of: <b>'hypocenter', 'centroid', 'amplitude',
  #   'macroseismic', 'rupture start', 'rupture end'</b>.
  # @attr_reader time [String] Focal date and time.
  # @attr_reader latitude [Float] Hypocenter latitude, with respect to the WGS84 reference system. Unit: deg
  # @attr_reader longitude [Float] Hypocenter longitude, with respect to the WGS84 reference system. Unit: deg
  # @attr_reader depth [Integer] Depth of hypocenter with respect to the nominal sea level given by the WGS84 geoid. Unit: m
  # @attr_reader uncertainty [Integer] The depth uncertainty of the origin. Unit: m
  # @attr_reader depth_type [String] Type of depth determination.
  #  Can be on of: <b>'from location', 'from moment tensor inversion', 'from from modeling of broad-band P waveforms',
  #  'constrained by depth phases', 'constrained by direct phases', 'constrained by depth and direct phases',
  #   'operator assigned', 'other'</b>.
  # @attr_reader origin_uncertainty [OriginUncertainty] The origin uncertainty of the origin.
  # @attr_reader quality [Quality] The quality of the origin.
  # @attr_reader evaluation_status [String] The evaluation status of the origin.
  #   Can be one of: <b>'preliminary', 'confirmed', 'reviewed', 'final', 'rejected'</b>.
  # @attr_reader method_id [String] The method ID of the origin. Identifies the method used for locating the event.
  # @attr_reader earth_model_id [String] Identifies the earth model used in methodID.
  # @attr_reader creation_info [CreationInfo] The creation info of the origin.
  # @attr_reader public_id [String] The public ID of the origin.
  class Origin
    attr_reader :evaluation_mode, :type, :time, :latitude, :longitude, :depth, :uncertainty, :depth_type, :origin_uncertainty, :quality,
                :evaluation_status, :method_id, :earth_model_id, :creation_info, :public_id

    # Initializes a new Origin instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the origin of an event.
    def initialize(data)
      @evaluation_mode = data.fetch('evaluationMode', nil)
      @type = data.fetch('type', nil)
      @time = data.dig('time', 'value')
      @latitude = data.dig('latitude', 'value')&.to_f
      @longitude = data.dig('longitude', 'value')&.to_f
      @depth = data.dig('depth', 'value')&.to_i
      @uncertainty = data.dig('depth', 'uncertainty')&.to_i
      @depth_type = data.fetch('depthType', nil)
      @origin_uncertainty = data.fetch('originUncertainty', nil)&.then { |origin_uncertainty_data| OriginUncertainty.new(origin_uncertainty_data) }
      @quality = data.fetch('quality', nil)&.then { |quality_data| Quality.new(quality_data) }
      @evaluation_status = data.fetch('evaluationStatus', nil)
      @method_id = data.fetch('methodID', nil)
      @earth_model_id = data.fetch('earthModelID', nil)
      @creation_info = data.fetch('creationInfo', nil)&.then { |creation_info_data| CreationInfo.new(creation_info_data) }
      @public_id = data.fetch('publicID', nil)
    end
  end
end
