require 'esplanade/middleware'
require 'esplanade/safe_middleware'
require 'esplanade/dangerous_middleware'
require 'esplanade/check_custom_response_middleware'
require 'esplanade/configuration'

module Esplanade
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
