require 'tomograph'
require 'esplanade/request'
require 'esplanade/response'

module Esplanade
  class CheckCustomResponseMiddleware
    def initialize(app, **params)
      @app = app
      @documentation = Tomograph::Tomogram.new(Esplanade.configuration.params.merge(params))
    end

    def call(env)
      request = Esplanade::Request.new(@documentation, env)

      status, headers, body = @app.call(env)

      response = Esplanade::Response.new(request, status, body)
      response.validation.valid!

      [status, headers, body]
    end
  end
end
