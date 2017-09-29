require 'json-schema'
require 'esplanade/response/raw'

module Esplanade
  class Response
    attr_reader :request

    def initialize(status, raw_body, request)
      @status = status
      @raw_body = raw_body
      @request = request
    end

    def raw
      @raw ||= Esplanade::Response::Raw.new(@status, @raw_body)
    end

    def documentation
      @documentation ||= if @request && @request.documentation
        @request.documentation.find_responses(status: @status)
      end
    end

    def json_schemas
      @json_schemas ||= if documentation
        documentation.map { |action| action['body'] }
      end
    end

    def error
      return @error if @error
      return nil unless json_schemas
      return nil if json_schemas == []
      return nil unless raw.body
      return nil unless raw.body.to_h
      return @error = JSON::Validator.fully_validate(json_schemas.first, raw.body.to_h) if json_schemas.size == 1

      json_schemas.each do |json_schema|
        res = JSON::Validator.fully_validate(json_schema, raw.body.to_h)
        return @error = res if res == []
      end

      @error = ['invalid']
    end

    def documented?
      @documented ||= documentation != [] && !documentation.nil?
    end

    def has_json_schemas?
      @has_json_schemas ||= json_schemas.all? { |json_schema| json_schema != {} }
    end

    def body_json?
      raw.body.json?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
