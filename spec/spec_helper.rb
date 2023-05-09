# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'ingv_quake'
require 'faraday'
require 'faraday/decode_xml'
require_relative 'support/faraday_stubs_helper'

FDSNWS_EVENT_QUERY = '/fdsnws/event/1/query'

RSpec.configure do |config|
  config.include FaradayStubsHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random
end
