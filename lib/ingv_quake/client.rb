# frozen_string_literal: true

module IngvQuake
  # The Client class is responsible for making HTTP requests to the INGV Earthquake
  # web services API. It provides methods to initialize a connection, retrieve event
  # resources, and configure the underlying Faraday adapter.
  class Client
    # The base URL for the INGV Earthquake web services API.
    BASE_URL = 'https://webservices.ingv.it/'

    attr_reader :adapter

    # Initializes a new Client instance with an optional adapter and stubs.
    #
    # @example Faraday adapter and stubs can be customized
    #   client = IngvQuake::Client.new(adapter: MyAdapter, stubs: MyStubs)
    # @param adapter [Symbol, Class] Faraday adapter to use for making HTTP requests.
    # @param stubs [Faraday::Adapter::Test::Stubs] Optional stubs to use for testing.
    def initialize(adapter: Faraday.default_adapter, stubs: nil)
      @adapter = adapter
      @stubs = stubs
    end

    # Initializes an EventResource instance for fetching events from the API.
    #
    # @example Initialize new client and call `get_events`
    #   client = IngvQuake::Client.new
    #   events = client.get_events
    #
    # @return [EventResource] An instance of EventResource configured with the current client.
    def get_events
      EventResource.new(self)
    end

    # Initializes a Faraday connection with the INGV Earthquake API base URL and
    # XML headers. Configures the response to be parsed as XML and sets the adapter
    # with optional stubs.
    #
    # @return [Faraday::Connection] The Faraday connection instance.
    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |conn|
        conn.response :xml
        conn.adapter adapter, @stubs
      end
    end
  end
end
