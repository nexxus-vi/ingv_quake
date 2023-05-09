# frozen_string_literal: true

module IngvQuake
  # The ApplicationService class serves as a base class for other service classes
  # within the IngvQuake module. This class provides a convenient way to call services
  # by automatically instantiating and calling the service.
  class ApplicationService
    # Calls the service with the given arguments and block.
    #
    # @param args [Array] The arguments to pass to the service's initializer.
    # @param block [Proc] An optional block to pass to the service's initializer.
    # @return [Object] The result of the service's call method.
    def self.call(*args, &block)
      new(*args, &block).call
    end
  end
end
