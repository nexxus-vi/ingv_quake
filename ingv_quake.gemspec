# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ingv_quake/version'

Gem::Specification.new do |spec|
  spec.name          = 'ingv_quake'
  spec.version       = IngvQuake::VERSION
  spec.author        = 'Vi'
  spec.email         = ['nexxus-vi.1hod0@slmails.com']

  spec.summary       = 'Easy-to-use interface for querying the INGV Earthquake APIs with ease'
  spec.description   = <<-DESC
                          The ingv_quake gem is a powerful and flexible Ruby library designed to interact with the INGV Earthquake APIs.
                          It provides an easy-to-use interface for querying earthquake data, allowing developers to fetch events with specific filters and helper methods.
                          With ingv_quake, you can effortlessly obtain earthquake data and simplify the process of retrieving earthquake information.
                          This enables developers to focus on building meaningful applications and analysis tools for earthquake data.
  DESC
  spec.homepage      = 'https://github.com/nexxus-vi/ingv_quake'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.0'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '>= 1.12.1'
  spec.add_development_dependency 'simplecov' '>= 0.18.0'
  spec.add_development_dependency 'yard', '~> 0.9.34'

  spec.add_dependency 'faraday', '~> 2.7', '>= 2.7.4'
  spec.add_dependency 'faraday-decode_xml'
  spec.add_dependency 'geocoder', '~> 1.8'
end
