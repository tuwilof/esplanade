require 'tomograph'
require 'esplanade/request'
require 'esplanade/response'

module Esplanade
  class Middleware
    def initialize(app)
      @app = app
      @tomogram = Tomograph::Tomogram.new(
        prefix: Esplanade.configuration.prefix,
        apib_path: Esplanade.configuration.apib_path,
        drafter_yaml_path: Esplanade.configuration.drafter_yaml_path
      )
    end

    def call(env)
      request = Request.new(env, @tomogram)
      status, headers, body = @app.call(env)
      response = Response.new(status, body, request)
      [status, headers, body]
    end
  end
end
