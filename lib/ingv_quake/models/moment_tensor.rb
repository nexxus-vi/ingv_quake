# frozen_string_literal: true

module IngvQuake
  # The MomentTensor class represents a moment tensor solution for an event. It is an optional part of a FocalMechanism
  # description.
  #
  # @attr_reader public_id [String] Resource identifier of MomentTensor.
  # @attr_reader variance_reduction [Float] Variance reduction of moment tensor inversion, given in percent (Dreger 2003).
  #  This is a goodness-of-fit measure.
  # @attr_reader double_couple [Float] Double couple parameter obtained from moment tensor inversion (decimal fraction between 0
  #   and 1).
  # @attr_reader clvd [Float] CLVD (compensated linear vector dipole) parameter obtained from moment tensor inversion (decimal
  #   fraction between 0 and 1).
  # @attr_reader iso [Float] Isotropic part obtained from moment tensor inversion (decimal fraction between 0 and 1).
  # @attr_reader derived_origin_id [String] Refers to the publicID of the Origin derived in the moment tensor inversion.
  # @attr_reader moment_magnitude_id [String] Refers to the publicID of the Magnitude object which represents the derived moment
  #   magnitude.
  # @attr_reader tensor [Hash] Tensor object holding the moment tensor elements.
  # @attr_reader scalar_moment [Float] Scalar moment as derived in moment tensor inversion. Unit: N m.
  # @attr_reader data_used [DataUsed] Describes waveform data used for moment-tensor inversion.
  # @attr_reader creation_info [CreationInfo] The creation information for the moment tensor.
  class MomentTensor
    attr_reader :public_id, :variance_reduction, :double_couple, :clvd, :iso,
                :derived_origin_id, :moment_magnitude_id, :tensor, :scalar_moment,
                :data_used, :creation_info

    # Initializes a new MomentTensor instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the data used for a moment-tensor inversion.
    def initialize(data)
      @public_id = data.fetch('publicID', nil)
      @variance_reduction = data.fetch('varianceReduction', nil)&.to_f
      @double_couple = data.fetch('doubleCouple', nil)&.to_f
      @clvd = data.fetch('clvd', nil)&.to_f
      @iso = data.fetch('iso', nil)&.to_f
      @derived_origin_id = data.fetch('derivedOriginID', nil)
      @moment_magnitude_id = data.fetch('momentMagnitudeID', nil)
      @tensor = parse_tensor(data.fetch('tensor', {}))
      @scalar_moment = data.dig('scalarMoment', 'value')&.to_f
      @data_used = data.fetch('dataUsed', nil)&.then { |data_used_data| DataUsed.new(data_used_data) }
      @creation_info = data.fetch('creationInfo', nil)&.then { |creation_info_data| CreationInfo.new(creation_info_data) }
    end

    def parse_tensor(tensor_data)
      tensor = {}
      tensor_data.each do |key, value_data|
        tensor[key] = value_data.dig('value')&.to_f
      end
      tensor
    end
  end
end
