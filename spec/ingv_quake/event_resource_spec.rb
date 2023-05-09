# frozen_string_literal: true

module IngvQuake
  RSpec.describe EventResource do
    let(:client) { Client.new }
    let(:event_resource) { EventResource.new(client) }
    let(:xml_response) { read_fixture_file('full_info_event_response.xml') }
    let(:string_response) { read_fixture_file('basic_info_event_response.txt') }

    describe 'EventResource methods' do
      let(:response) { instance_double(Faraday::Response, status: 200, headers: { 'Content-Type' => 'application/xml' }, body: xml_response) }

      before do
        allow(event_resource).to receive(:send_request).with(params).and_return(response)
      end

      describe '#where' do
        let(:params) { { minmag: 3, maxmag: 5 } }

        it 'calls send_request with the given params' do
          event_resource.where(**params)
          expect(event_resource).to have_received(:send_request).with(params)
        end
      end

      describe '#between_dates' do
        let(:starttime) { '2023-04-15T00:00:00' }
        let(:endtime) { '2023-04-16T00:00:00' }
        let(:params) { { starttime: starttime, endtime: endtime } }

        it 'calls send_request with the given params' do
          event_resource.between_dates(starttime: starttime, endtime: endtime)
          expect(event_resource).to have_received(:send_request).with(params)
        end
      end

      describe '#starting_from' do
        let(:starttime) { DateTime.now.strftime('%Y-%m-%dT%H:%M:%S') }
        let(:params) { { starttime: starttime } }

        it 'calls starting_from with the required param' do
          event_resource.starting_from(starttime: starttime)
          expect(event_resource).to have_received(:send_request).with(params)
        end
      end

      describe '#between_magnitude' do
        let(:minmag) { 1.2 }
        let(:maxmag) { 5.5 }
        let(:params) { { minmag: minmag, maxmag: maxmag } }

        it 'calls starting_from with the required params' do
          event_resource.between_magnitude(minmag: minmag, maxmag: maxmag)
          expect(event_resource).to have_received(:send_request).with({ minmag: minmag, maxmag: maxmag })
        end
      end

      describe '#within_last_hour' do
        let(:an_hour_ago) { DateTime.now - Rational(1, 24) }
        let(:params) { { starttime: an_hour_ago.strftime('%Y-%m-%dT%H:%M:%S') } }

        it 'calls within_last_hour without params' do
          event_resource.within_last_hour
          expect(event_resource).to have_received(:send_request).with(params)
        end
      end

      describe '#within_last_day' do
        let(:yesterday) { DateTime.now.prev_day }
        let(:params) { { starttime: yesterday.strftime('%Y-%m-%dT%H:%M:%S') } }

        it 'calls within_last_day without params' do
          event_resource.within_last_day
          expect(event_resource).to have_received(:send_request).with(params)
        end
      end

      describe '#within_last_week' do
        let(:a_week_ago) { DateTime.now - 7 }
        let(:params) { { starttime: a_week_ago.strftime('%Y-%m-%dT%H:%M:%S') } }

        it 'calls within_last_week without params' do
          event_resource.within_last_week
          expect(event_resource).to have_received(:send_request).with(params)
        end
      end

      describe '#within_last_month' do
        let(:a_month_ago) { DateTime.now.prev_month }
        let(:params) { { starttime: a_month_ago.strftime('%Y-%m-%dT%H:%M:%S') } }

        it 'calls within_last_month without params' do
          event_resource.within_last_month
          expect(event_resource).to have_received(:send_request).with(params)
        end
      end
    end

    describe 'stubbed request for BasicInfoEvent' do
      let(:text_response) { read_fixture_file('basic_info_event_response.txt') }
      let(:stub_definitions) { [{ method: :get, path: FDSNWS_EVENT_QUERY, status: 200, headers: { 'Content-Type' => 'text/plain;charset=UTF-8' }, response: text_response }] }
      let(:stubs) { create_faraday_stubs(stub_definitions) }
      let(:client) { Client.new(adapter: :test, stubs: stubs) }

      it 'stubs the response with the contents of the text file' do
        events = client.get_events.within_last_day(limit: 2, format: 'text')

        expect(2).to eq(events.size)
        expect(events.first).to be_a(BasicInfoEvent)
        expect('34726341').to eq(events.first.event_id)
        expect('0.9').to eq(events.first.magnitude)
        expect('5 km NW Bagno di Romagna (FC)').to eq(events.first.location)
        expect(events.first.catalog).to be_empty
      end
    end

    describe 'stubbed request for FullInfoEvent' do
      let(:xml_response) { read_fixture_file('full_info_event_response.xml') }
      let(:stub_definitions) { [{ method: :get, path: FDSNWS_EVENT_QUERY, status: 200, headers: { 'Content-Type' => 'application/xml' }, response: xml_response }] }
      let(:stubs) { create_faraday_stubs(stub_definitions) }
      let(:client) { Client.new(adapter: :test, stubs: stubs) }

      it 'gets response from the xml file' do
        events = client.get_events.within_last_day(limit: 3)
        first_event = events.first
        last_event = events.last

        expect(3).to eq(events.size)

        expect(first_event).to be_a(FullInfoEvent)
        expect(1.1).to eq(first_event.magnitude.value)
        expect('INGV').to eq(first_event.creation_info.agency_id)
        expect('uncertainty ellipse').to eq(first_event.origin.origin_uncertainty.preferred_description)
        expect(310.0).to eq(first_event.origin.origin_uncertainty.horizontal_uncertainty)
        expect(278).to eq(first_event.origin.origin_uncertainty.min_horizontal_uncertainty)

        expect('earthquake').to eq(last_event.type)
        expect('Ryukyu Islands, Japan [Sea: Japan]').to eq(last_event.location)
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?magnitudeId=125426801').to eq(last_event.preferred_magnitude_id)
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?originId=116792731').to eq(last_event.preferred_origin_id)
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?eventId=34819311').to eq(last_event.public_id)

        # creation_info
        expect('INGV').to eq(last_event.creation_info.agency_id)
        expect('SURVEY-INGV').to eq(last_event.creation_info.author)
        expect('2023-04-27T08:02:05').to eq(last_event.creation_info.creation_time)
        expect('0').to eq(last_event.creation_info.id_locator)

        # origin
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?originId=116792731').to eq(last_event.origin.public_id)
        expect('manual').to eq(last_event.origin.evaluation_mode)
        expect('hypocenter').to eq(last_event.origin.type)
        expect('2023-04-27T07:43:40.000000').to eq(last_event.origin.time)
        expect(26).to eq(last_event.origin.latitude)
        expect(128.6).to eq(last_event.origin.longitude)
        expect(10000).to eq(last_event.origin.depth)
        expect(0).to eq(last_event.origin.uncertainty)
        expect('from location').to eq(last_event.origin.depth_type)
        expect('reviewed').to eq(last_event.origin.evaluation_status)
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?methodId=11').to eq(last_event.origin.method_id)
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?earthModelId=51').to eq(last_event.origin.earth_model_id)

        # origin.quality
        expect(1).to eq(last_event.origin.quality.associated_phase_count)
        expect(1).to eq(last_event.origin.quality.used_phase_count)
        expect(0).to eq(last_event.origin.quality.associated_station_count)
        expect(0).to eq(last_event.origin.quality.used_station_count)
        expect(nil).to eq(last_event.origin.quality.azimuthal_gap)
        expect(nil).to eq(last_event.origin.quality.maximum_distance)
        expect(nil).to eq(last_event.origin.quality.minimum_distance)
        expect(nil).to eq(last_event.origin.quality.standard_error)

        # origin.creation_info
        expect('INGV').to eq(last_event.origin.creation_info.agency_id)
        expect('SURVEY-INGV').to eq(last_event.origin.creation_info.author)
        expect('2023-04-27T08:02:05').to eq(last_event.origin.creation_info.creation_time)
        expect(nil).to eq(last_event.origin.creation_info.id_locator)
        expect('200').to eq(last_event.origin.creation_info.version)

        # magnitude
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?magnitudeId=125426801').to eq(last_event.magnitude.public_id)
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?originId=116792731').to eq(last_event.magnitude.origin_id)
        expect('Mwp').to eq(last_event.magnitude.type)
        expect(5.6).to eq(last_event.magnitude.value)
        expect(0.0).to eq(last_event.magnitude.uncertainty)
        expect('smi:webservices.ingv.it/fdsnws/event/1/query?methodId=11').to eq(last_event.magnitude.method_id)

        # magnitude.creation_info
        expect('INGV').to eq(last_event.magnitude.creation_info.agency_id)
        expect('Sala Sismica INGV-Roma').to eq(last_event.magnitude.creation_info.author)
        expect('2023-04-27T08:02:05').to eq(last_event.magnitude.creation_info.creation_time)

        #origin.origin_uncertainty
        expect(nil).to eq(last_event.origin.origin_uncertainty)
        expect(nil).to eq(last_event.origin.origin_uncertainty&.preferred_description)
        expect(nil).to eq(last_event.origin.origin_uncertainty&.horizontal_uncertainty)
        expect(nil).to eq(last_event.origin.origin_uncertainty&.min_horizontal_uncertainty)
      end
    end

    describe 'actual client' do
      let(:client) { Client.new }

      it 'makes the request and maps the response to an array of BasicInfoEvent objects' do
        events = client.get_events.within_last_day(format: 'text', limit: 2)

        expect(2).to eq(events.size)
        expect(events.first).to be_a(BasicInfoEvent)
        expect(events.first).to respond_to(:magnitude)
        expect(events.first).to respond_to(:location)
        expect(events.first).not_to respond_to(:origin)
      end

      it 'makes the request and maps the response to an array of FullInfoEvent objects' do
        events = client.get_events.within_last_day(limit: 2)

        expect(2).to eq(events.size)
        expect(events.first).to be_a(FullInfoEvent)
        expect(events.first).to respond_to(:creation_info)
        expect(events.first).to respond_to(:origin)
        expect(events.first.origin).to respond_to(:quality)
        expect(events.first).not_to respond_to(:contributor)
        expect(events.first).not_to respond_to(:mag_type)
      end

      it 'transforms address to coordinates successfully' do
        event = client.get_events.where(address: 'Roma, Via Condotti', maxradiuskm: 1000, limit: 1).first

        expect(event).to be_a(FullInfoEvent)
      end

      it 'raises AddressNotFoundError when no location is found' do
        expect do
          client.get_events.where(address: 'Romapiazza', maxradiuskm: 150)
        end.to raise_error(AddressNotFoundError)
      end

      it 'raises ParamMissingError when radius is missing and address is present' do
        expect do
          client.get_events.within_last_day(format: 'text', limit: 2, address: 'Roma, Via condotti 1')
        end.to raise_error(ParamMissingError)
      end

      it 'raises ParamMissingError when radius is missing and lat & lon are present' do
        expect do
          client.get_events.within_last_day(format: 'text', limit: 2, lat: 42.123, lon: 12.123)
        end.to raise_error(ParamMissingError)
      end

      it 'raises ArgumentError when a required parameter is missing' do
        expect { client.get_events.starting_from(format: 'text') }.to raise_error(ArgumentError)
      end
    end
  end
end
