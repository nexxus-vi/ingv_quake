# frozen_string_literal: true

module FaradayStubsHelper
  def read_fixture_file(filename)
    File.read(File.join('spec', 'fixtures', filename))
  end

  def create_faraday_stubs(stub_definitions)
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub_definitions.each do |definition|
        stub.send(definition[:method], definition[:path]) do |_env|
          [definition[:status], definition[:headers] || {}, definition[:response]]
        end
      end
    end
  end
end
