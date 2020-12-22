require 'tomograph'
require 'esplanade/request'
require 'esplanade/response'

module Esplanade
  class SafeMiddleware
    def initialize(app, **params)
      @app = app
      @documentation = Tomograph::Tomogram.new(Esplanade.configuration.params.merge(params))
    end

    def call(env)
      request = Esplanade::Request.new(@documentation, env)
      check_request(request)

      status, headers, body = @app.call(env)

      response = Esplanade::Response.new(request, status, body)
      check_response(response)

      [status, headers, body]
    end

    def check_request(request)
      request.validation.valid!
      Rails.logger.debug 'ESPLANADE SAYS THAT THE REQUEST IS VALID'
    rescue Esplanade::Request::Error => e
      Rails.logger.debug "ESPLANADE SKIP: #{e.inspect}"
    end

    def check_response(response)
      response.validation.valid!
      Rails.logger.debug 'ESPLANADE SAYS THAT THE RESPONSE IS VALID'
    rescue Esplanade::Response::Error => e
      Rails.logger.debug "ESPLANADE SKIP: #{e.inspect}"
    end
  end
end
