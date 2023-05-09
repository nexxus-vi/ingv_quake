# frozen_string_literal: true

module IngvQuake
  # The OriginUncertainty class represents the metadata related to the origin uncertainty details of an event record
  #
  # @attr_reader preferred_description [String] Preferred uncertainty description.
  #   Can be one of: <b>'horizontal uncertainty', 'uncertainty ellipse', 'confidence ellipsoid'</b>.
  # @attr_reader horizontal_uncertainty [Float] Circular confidence region, given by single value of horizontal uncertainty. Unit: m.
  # @attr_reader min_horizontal_uncertainty [Integer] Semi-minor axis of confidence ellipse. Unit: m.
  # @attr_reader max_horizontal_uncertainty [Integer] Semi-major axis of confidence ellipse. Unit: m.
  # @attr_reader azimuth_max_horizontal_uncertainty [Integer] Azimuth of major axis of confidence ellipse. Measured clockwise from
  #   South-North direction at epicenter. Unit: deg.
  # @attr_reader confidence_level [Integer] Confidence level of the uncertainty, given in percent.
  class OriginUncertainty
    attr_reader :preferred_description, :horizontal_uncertainty, :min_horizontal_uncertainty,
                :max_horizontal_uncertainty, :azimuth_max_horizontal_uncertainty, :confidence_level

    # Initializes a new OriginUncertainty instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the origin uncertainty of an event.
    def initialize(data)
      @preferred_description = data.fetch('preferredDescription', nil)
      @horizontal_uncertainty = data.fetch('horizontalUncertainty', nil)&.to_f
      @min_horizontal_uncertainty = data.fetch('minHorizontalUncertainty', nil)&.to_i
      @max_horizontal_uncertainty = data.fetch('maxHorizontalUncertainty', nil)&.to_i
      @azimuth_max_horizontal_uncertainty = data.fetch('azimuthMaxHorizontalUncertainty', nil)&.to_i
      @confidence_level = data.fetch('confidenceLevel', nil)&.to_i
    end
  end
end
