require 'json-schema'
require 'esplanade/request/raw'

module Esplanade
  class Request
    def initialize(env, main_documentation)
      @env = env
      @main_documentation = main_documentation
    end

    def raw
      Esplanade::Request::Raw.new(@env)
    end

    def documentation
      @documentation ||= if @main_documentation
                           @main_documentation.find_request(method: raw.method, path: raw.path)
                         end
    end

    def json_schema
      @json_schema ||= if documentation
                         documentation.request
                       end
    end

    def error
      @error ||= if json_schema
                   JSON::Validator.fully_validate(json_schema, raw.body.to_h)
                 end
    end

    def documented?
      @documented ||= !documentation.nil?
    end

    def has_json_schema?
      @has_json_schema ||= json_schema != {}
    end

    def body_json?
      raw.body.json?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
