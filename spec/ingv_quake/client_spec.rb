# frozen_string_literal: true

module IngvQuake
  RSpec.describe Client do
    let(:string_response) { read_fixture_file('basic_info_event_response.txt') }
    let(:stubs) do
      stub_definitions = [{ method: :get, path: FDSNWS_EVENT_QUERY, status: 200, response: string_response }]
      create_faraday_stubs(stub_definitions)
    end
    let(:client) { Client.new(adapter: Faraday::Adapter::Test, stubs: stubs) }

    describe '#initialize' do
      it 'sets the adapter' do
        expect(client.adapter).to eq(Faraday::Adapter::Test)
      end

      it 'sets the stubs' do
        expect(client.instance_variable_get(:@stubs)).to eq(stubs)
      end
    end

    describe '#get_events' do
      it 'returns an instance of EventResource' do
        expect(client.get_events).to be_an_instance_of(EventResource)
      end
    end

    describe '#connection' do
      it 'creates a Faraday connection with the BASE_URL' do
        expect(client.connection.url_prefix.to_s).to eq(Client::BASE_URL)
      end

      it 'uses the specified adapter' do
        expect(client.connection.builder.adapter).to eq(Faraday::Adapter::Test)
      end
    end
  end
end
