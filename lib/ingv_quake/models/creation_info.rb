# frozen_string_literal: true

module IngvQuake
  # The CreationInfo class represents the metadata related to the creation of an event record
  #
  # @attr_reader agency_id [String] Designation of agency that published a resource. The string has a maximum length of 64 characters.
  # @attr_reader author [String] Name describing the author of a resource. The string has a maximum length of 128 characters.
  # @attr_reader creation_time [String] Time of creation of a resource, in ISO 8601 format. It has to be given in UTC.
  # @attr_reader id_locator [String] The ID locator of the creation info.
  # @attr_reader version [String] Version string of a resource.
  class CreationInfo
    attr_reader :agency_id, :author, :creation_time, :id_locator, :version

    # Initializes a new CreationInfo instance with the provided data.
    #
    # @param data [Hash] A hash containing detailed information about the creation of an event.
    def initialize(data)
      @agency_id = data.fetch('agencyID', nil)
      @author = data.fetch('author', nil)
      @creation_time = data.fetch('creationTime', nil)
      @id_locator = data.fetch('id_locator', nil)
      @version = data.fetch('version', nil)
    end
  end
end
