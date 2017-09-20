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

    def request_tomogram
      @schema ||= @tomogram.find_request(method: method, path: path)
    end

    def json_schema
      @json_schema ||= request_tomogram.request
    end

    def error
      @error ||= JSON::Validator.fully_validate(json_schema, body)
    end

    def documented?
      @documented ||= !request_tomogram.nil?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
