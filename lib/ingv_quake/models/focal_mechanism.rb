# frozen_string_literal: true

module IngvQuake
  # The FocalMechanism class represents the focal mechanism information of an event.
  #
  # @attr_reader public_id [String] Resource identifier of FocalMechanism.
  # @attr_reader triggering_origin_id [String] Refers to the publicID of the triggering origin.
  # @attr_reader nodal_plane1 [Hash] The first nodal plane of the focal mechanism.
  # @attr_reader nodal_plane2 [Hash] The second nodal plane of the focal mechanism.
  # @attr_reader creation_info [CreationInfo] The creation information for the focal mechanism.
  # @attr_reader evaluation_mode [String] The evaluation mode of the focal mechanism.
  # @attr_reader evaluation_status [String] The evaluation status of the focal mechanism.
  # @attr_reader moment_tensor [MomentTensor] The moment tensor information for the focal mechanism.
  class FocalMechanism
    attr_reader :public_id, :triggering_origin_id, :nodal_plane1, :nodal_plane2, :creation_info,
                :evaluation_mode, :evaluation_status, :moment_tensor

    # Initializes a new FocalMechanism instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the data used for an event focal mechanism.
    def initialize(data)
      @public_id = data.fetch('publicID', nil)
      @triggering_origin_id = data.fetch('triggeringOriginID', nil)
      @nodal_plane1, @nodal_plane2 = parse_nodal_planes(data.fetch('nodalPlanes', {}))
      @creation_info = data.fetch('creationInfo', nil)&.then { |creation_info_data| CreationInfo.new(creation_info_data) }
      @evaluation_mode = data.fetch('evaluationMode', nil)
      @evaluation_status = data.fetch('evaluationStatus', nil)
      @moment_tensor = data.fetch('momentTensor', nil)&.then { |moment_tensor_data| MomentTensor.new(moment_tensor_data) }
    end

    def parse_nodal_planes(planes)
      nodal_plane1 = parse_nodal_plane(planes.fetch('nodalPlane1', {}))
      nodal_plane2 = parse_nodal_plane(planes.fetch('nodalPlane2', {}))
      [nodal_plane1, nodal_plane2]
    end

    def parse_nodal_plane(plane_data)
      {
        strike: plane_data.dig('strike', 'value')&.to_i,
        dip: plane_data.dig('dip', 'value')&.to_i,
        rake: plane_data.dig('rake', 'value')&.to_i
      }
    end
  end
end
