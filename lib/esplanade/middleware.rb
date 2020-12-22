require 'tomograph'
require 'esplanade/request'
require 'esplanade/response'

module Esplanade
  class Middleware
    def initialize(app, **params)
      @app = app
      @documentation = Tomograph::Tomogram.new(Esplanade.configuration.params.merge(params))
    end

    def call(env)
      status, headers, body = @app.call(env)
      [status, headers, body]
    end
  end
end
