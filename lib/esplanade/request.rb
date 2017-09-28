require 'json-schema'
require 'esplanade/request/raw'
require 'esplanade/request/doc'

module Esplanade
  class Request
    def initialize(env, main_documentation)
      @env = env
      @main_documentation = main_documentation
    end

    def raw
      Esplanade::Request::Raw.new(@env)
    end

    def doc
      Esplanade::Request::Doc.new(@main_documentation, raw)
    end

    def error
      @error ||= if doc.json_schema
                   JSON::Validator.fully_validate(doc.json_schema, raw.body.to_h)
                 end
    end

    def documented?
      @documented ||= !doc.tomogram.nil?
    end

    def has_json_schema?
      @has_json_schema ||= doc.json_schema != {}
    end

    def body_json?
      raw.body.json?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
