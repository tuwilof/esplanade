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
      @request_tomogram ||= if @tomogram
                              @tomogram.find_request(method: method, path: path)
                            end
    end

    def json_schema
      @json_schema ||= if request_tomogram
                         request_tomogram.request
                       end
    end

    def error
      @error ||= if json_schema
                   JSON::Validator.fully_validate(json_schema, body)
                 end
    end

    def documented?
      @documented ||= !request_tomogram.nil?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
