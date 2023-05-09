# frozen_string_literal: true

module IngvQuake
  # The BasicInfoEventParser class is responsible for parsing response data containing
  # basic information about earthquake events. It inherits from the ApplicationService
  # base class.
  class BasicInfoEventParser < ApplicationService
    attr_reader :response

    # Initializes a new BasicInfoEventParser instance with the response data.
    #
    # @param response [String] The response data to be parsed.
    def initialize(response)
      @response = response
    end

    # Parses the response data and creates an array of BasicInfoEvent objects.
    #
    # @return [Array<BasicInfoEvent>] An array of BasicInfoEvent objects.
    def call
      @response.lines.drop(1).map do |line|
        BasicInfoEvent.new(*line.strip.split('|'))
      end
    end
  end
end
