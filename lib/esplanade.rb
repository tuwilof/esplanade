require 'esplanade/middleware'
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
