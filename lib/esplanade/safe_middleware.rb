require 'tomograph'
require 'esplanade/request'
require 'esplanade/response'

module Esplanade
  class SafeMiddleware
    def initialize(app)
      @app = app
      @documentation = Tomograph::Tomogram.new(
        prefix: Esplanade.configuration.prefix,
        apib_path: Esplanade.configuration.apib_path,
        drafter_yaml_path: Esplanade.configuration.drafter_yaml_path
      )
    end

    def call(env)
      request = Esplanade::Request.new(@documentation, env)
      begin
        request.validation.valid!
        Rails.logger.debug 'ESPLANADE SAYS THAT THE REQUEST IS VALID'
      rescue Esplanade::Request::Error => e
        Rails.logger.debug "ESPLANADE SKIP: #{e.inspect}"
      end

      status, headers, body = @app.call(env)

      response = Esplanade::Response.new(request, status, body)
      begin
        response.validation.valid!
        Rails.logger.debug 'ESPLANADE SAYS THAT THE RESPONSE IS VALID'
      rescue Esplanade::Response::Error => e
        Rails.logger.debug "ESPLANADE SKIP: #{e.inspect}"
      end

      [status, headers, body]
    end
  end
end
