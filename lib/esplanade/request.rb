require 'json-schema'
require 'esplanade/request/body'

module Esplanade
  class Request
    def initialize(env, tomogram)
      @env = env
      @tomogram = tomogram
    end

    def method
      @method ||= @env['REQUEST_METHOD']
    end

    def path
      @path ||= @env['PATH_INFO']
    end

    def body
      @body ||= Esplanade::Request::Body.craft(@env)
    end

    def schema
      @schema ||= @tomogram.find_request(method: method, path: path)
    end

    def error
      @error ||= JSON::Validator.fully_validate(schema.request, body)
    end

    def documented?
      @documented ||= !schema.nil?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
