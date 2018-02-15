require 'esplanade/middleware'
require 'esplanade/middlewares/safe_middleware'
require 'esplanade/middlewares/dangerous_middleware'
require 'esplanade/middlewares/check_custom_response_middleware'
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
