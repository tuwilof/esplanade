require 'yaml'

module Esplanade
  class Middleware
    class Exit < RuntimeError; end
    class ResponseNotDoc < RuntimeError; end

    def initialize(app)
      @app = app
      @tomogram = Tomograph::Tomogram.new(
        prefix: Esplanade.configuration.prefix,
        apib_path: Esplanade.configuration.apib_path,
        drafter_yaml_path: Esplanade.configuration.drafter_yaml_path
      )
    end

    def call(env)
      valid!(env)
    rescue Request::NotDocumented
      Request::Error.not_documented
    rescue Response::NotDocumented
      Response::Error.not_documented
    rescue Request::Unsuitable => e
      Request::Error.unsuitable(e.message)
    rescue Response::Unsuitable => e
      Response::Error.unsuitable(e.message)
    end

    def valid!(env)
      request = Request.new(env, @tomogram)
      request.valid! if request.validate?
      status, headers, body = @app.call(env)
      response = Response.new(status, body, request.schema)
      response.valid! if response.validate?
      [status, headers, body]
    end
  end
end
