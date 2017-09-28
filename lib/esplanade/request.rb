require 'json-schema'
require 'esplanade/request/body'

module Esplanade
  class Request
    def initialize(env, main_documentation)
      @env = env
      @main_documentation = main_documentation
    end

    def method
      @method ||= @env['REQUEST_METHOD']
    end

    def path
      @path ||= @env['PATH_INFO']
    end

    def body
      @body ||= Esplanade::Request::Body.new(@env)
    end

    def documentation
      @documentation ||= if @main_documentation
                           @main_documentation.find_request(method: method, path: path)
                         end
    end

    def json_schema
      @json_schema ||= if documentation
                         documentation.request
                       end
    end

    def error
      @error ||= if json_schema
                   JSON::Validator.fully_validate(json_schema, body.to_h)
                 end
    end

    def documented?
      @documented ||= !documentation.nil?
    end

    def has_json_schema?
      @has_json_schema ||= json_schema != {}
    end

    def body_json?
      body.json?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
