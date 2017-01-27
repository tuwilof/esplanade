require 'esplanade/middleware'
require 'esplanade/configuration'
require 'esplanade/request'
require 'esplanade/request/body'
require 'esplanade/request/error'
require 'esplanade/response'
require 'esplanade/response/body'
require 'esplanade/response/error'
require 'esplanade/railtie' if defined?(Rails)
require 'tomogram_routing'

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
