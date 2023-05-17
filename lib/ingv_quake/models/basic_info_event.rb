# frozen_string_literal: true

module IngvQuake
  # The BasicInfoEvent struct represents a simplified event with essential information.
  # Example:
  #  #<struct IngvQuake::BasicInfoEvent
  #  event_id="34898181",
  #  time="2023-05-06T00:58:38.360000",
  #  latitude="37.6962",
  #  longitude="12.9447",
  #  depth_km="11.2",
  #  author="SURVEY-INGV",
  #  catalog="",
  #  contributor="",
  #  contributor_id="",
  #  mag_type="ML",
  #  magnitude="1.8",
  #  mag_author="--",
  #  location="4 km W Montevago (AG)",
  #  type="earthquake">
  #
  # @!attribute event_id
  #   @return [String] The unique ID of the event.
  # @!attribute time
  #   @return [String] The date and time of the event.
  # @!attribute latitude
  #   @return [String] The latitude of the event.
  # @!attribute longitude
  #   @return [String] The longitude of the event.
  # @!attribute depth_km
  #   @return [String] The depth of the event in kilometers.
  # @!attribute author
  #   @return [String] The author of the event information.
  # @!attribute catalog
  #   @return [String] The catalog the event belongs to.
  # @!attribute contributor
  #   @return [String] The contributor of the event information.
  # @!attribute contributor_id
  #   @return [String] The unique ID of the contributor.
  # @!attribute mag_type
  #   @return [String] The type of magnitude for the event.
  # @!attribute magnitude
  #   @return [String] The magnitude of the event.
  # @!attribute mag_author
  #   @return [String] The author of the event's magnitude information.
  # @!attribute location
  #   @return [String] The location of the event.
  # @!attribute type
  #   @return [String] The type of the event.
  # @!attribute intensity_map
  #   @return [String] The intensity map of the event. <b>This is a custom attribute.<b>
  # @!attribute pga_map
  #   @return [String] The pga map of the event. <b>This is a custom attribute.<b>
  # @!attribute pgv_map
  #   @return [String] The pgv map of the event. <b>This is a custom attribute.<b>
  BasicInfoEvent = Struct.new(
    :event_id, :time, :latitude, :longitude, :depth_km, :author, :catalog, :contributor,
    :contributor_id, :mag_type, :magnitude, :mag_author, :location, :type, :intensity_map, :pga_map, :pgv_map,
    keyword_init: true
  )
end
