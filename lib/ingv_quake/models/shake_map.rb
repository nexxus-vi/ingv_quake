# frozen_string_literal: true

module IngvQuake
  # The ShakeMap class contains the map urls related to the Event.
  #
  # @attr_reader intensity_map [String] Intensity map of the Event.
  # @attr_reader pga_map [String] PGA map of Event.
  # @attr_reader pgv_map [String] PGV map of Event.
  class ShakeMap
    attr_reader :intensity_map, :pga_map, :pgv_map

    def initialize(data)
      @intensity_map = data.fetch('intensity_map', nil)
      @pga_map = data.fetch('pga_map', nil)
      @pgv_map = data.fetch('pgv_map', nil)
    end
  end
end
