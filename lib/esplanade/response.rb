require 'json-schema'
require 'esplanade/response/raw'
require 'esplanade/response/doc'

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

    def doc
      @doc ||= Esplanade::Response::Doc.new(@status, @request)
    end

    def error
      return @error if @error
      return nil unless doc.json_schemas
      return nil if doc.json_schemas == []
      return nil unless raw.body
      return nil unless raw.body.to_h
      return @error = JSON::Validator.fully_validate(doc.json_schemas.first, raw.body.to_h) if doc.json_schemas.size == 1

      doc.json_schemas.each do |json_schema|
        res = JSON::Validator.fully_validate(json_schema, raw.body.to_h)
        return @error = res if res == []
      end

      @error = ['invalid']
    end

    def documented?
      @documented ||= doc.tomogram != [] && !doc.tomogram.nil?
    end

    def has_json_schemas?
      @has_json_schemas ||= doc.json_schemas.all? { |json_schema| json_schema != {} }
    end

    def body_json?
      raw.body.json?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
