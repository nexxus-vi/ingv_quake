# frozen_string_literal: true

module IngvQuake
  RSpec.describe Resource do
    let(:client) { instance_double(Client) }
    let(:connection) { instance_double(Faraday::Connection) }
    let(:resource) { Resource.new(client) }
    let(:string_response) { read_fixture_file('basic_info_event_response.txt') }
    let(:xml_response) { read_fixture_file('full_info_event_response.xml') }

    describe '#get_events_request' do
      let(:params) { { minmag: 4, limit: 2 } }

      context 'when the response is successful' do
        context 'when the response is an XML response' do
          let(:response) { instance_double(Faraday::Response, status: 200, headers: { 'Content-Type' => 'application/xml' }, body: xml_response) }

          before do
            allow(client).to receive(:connection).and_return(connection)
            allow(client.connection).to receive(:get).with(FDSNWS_EVENT_QUERY, params).and_return(response)
          end

          it 'returns an array of FullInfoEvent objects' do
            expect(FullInfoEventParser).to receive(:call).with(xml_response)
            resource.get_events_request(params: params)
          end
        end

        context 'when the response is a string response' do
          let(:response) { instance_double(Faraday::Response, status: 200, headers: { 'Content-Type' => 'text/plain' }, body: string_response) }

          before do
            allow(client).to receive(:connection).and_return(connection)
            allow(client.connection).to receive(:get).with(FDSNWS_EVENT_QUERY, params).and_return(response)
          end

          it 'returns an array of BasicInfoEvent objects' do
            expect(BasicInfoEventParser).to receive(:call).with(string_response)
            resource.get_events_request(params: params)
          end
        end
      end

      context 'when the response has an error status' do
        Resource::ERROR_MESSAGES.each do |status, message|
          context "when the status is #{status}" do
            let(:error_response) { instance_double(Faraday::Response, status: status, body: 'Error message') }

            before do
              allow(client).to receive(:connection).and_return(connection)
              allow(client.connection).to receive(:get).with(FDSNWS_EVENT_QUERY, params).and_return(error_response)
            end

            it "raises an IngvQuake::Resource::Error with the message '#{message}'" do
              expect { resource.get_events_request(params: params) }.to raise_error(Error, "#{message} Error message")
            end
          end
        end
      end
    end
  end
end
