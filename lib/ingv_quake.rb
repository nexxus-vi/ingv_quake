# frozen_string_literal: true

require 'faraday'
require 'faraday/decode_xml'
require 'ingv_quake/version'

module IngvQuake
  class Error < StandardError; end
  class ParamMissingError < Error; end
  class AddressNotFoundError < Error; end

  autoload :IngvQuake, 'lib/ingv_quake'

  autoload :Client, 'ingv_quake/client'
  autoload :Resource, 'ingv_quake/resource'

  # Resources
  autoload :EventResource, 'ingv_quake/resources/events'

  # Service Objects
  autoload :ApplicationService, 'ingv_quake/services/application_service'
  autoload :BasicInfoEventParser, 'ingv_quake/services/basic_info_event_parser'
  autoload :FullInfoEventParser, 'ingv_quake/services/full_info_event_parser'

  # Models
  autoload :BasicInfoEvent, 'ingv_quake/models/basic_info_event'
  autoload :CreationInfo, 'ingv_quake/models/creation_info'
  autoload :DataUsed, 'ingv_quake/models/data_used'
  autoload :FocalMechanism, 'ingv_quake/models/focal_mechanism'
  autoload :FullInfoEvent, 'ingv_quake/models/full_info_event'
  autoload :Magnitude, 'ingv_quake/models/magnitude'
  autoload :MomentTensor, 'ingv_quake/models/moment_tensor'
  autoload :Origin, 'ingv_quake/models/origin'
  autoload :OriginUncertainty, 'ingv_quake/models/origin_uncertainty'
  autoload :Quality, 'ingv_quake/models/quality'
end
