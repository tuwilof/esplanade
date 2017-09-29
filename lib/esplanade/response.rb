require 'esplanade/response/raw'
require 'esplanade/response/doc'
require 'esplanade/response/validation'

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

    def validation
      @validation ||= Esplanade::Response::Validation.new(raw, doc)
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
  end
end
