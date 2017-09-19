require 'json-schema'

module Esplanade
  class Request
    attr_accessor :path, :method, :body, :schema

    class Unsuitable < RuntimeError; end
    class NotDocumented < RuntimeError; end

    def initialize(env, tomogram)
      @method = env['REQUEST_METHOD']
      @path = env['PATH_INFO']
      @body = Body.craft(env)
      @schema = tomogram.find_request(method: @method, path: @path)
      raise NotDocumented unless schema || Esplanade.configuration.skip_not_documented
      self
    end

    def error
      JSON::Validator.fully_validate(@schema.request, @body)
    end

    def valid!
      raise Unsuitable, error unless error.empty?
    end

    def validate?
      @schema && Esplanade.configuration.validation_requests
    end
  end
end
