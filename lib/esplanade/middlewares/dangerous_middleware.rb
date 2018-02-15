require 'tomograph'
require 'esplanade/request'
require 'esplanade/response'

module Esplanade
  class DangerousMiddleware
    def initialize(
      app,
      prefix: Esplanade.configuration.prefix,
      apib_path: Esplanade.configuration.apib_path,
      drafter_yaml_path: Esplanade.configuration.drafter_yaml_path
    )
      @app = app
      @documentation = Tomograph::Tomogram.new(
        prefix: prefix,
        apib_path: apib_path,
        drafter_yaml_path: drafter_yaml_path
      )
    end

    def call(env)
      request = Esplanade::Request.new(@documentation, env)
      request.validation.valid!

      status, headers, body = @app.call(env)

      response = Esplanade::Response.new(request, status, body)
      response.validation.valid!

      [status, headers, body]
    end
  end
end
