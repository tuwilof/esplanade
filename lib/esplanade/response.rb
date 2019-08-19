require 'esplanade/response/doc'
require 'esplanade/response/raw'
require 'esplanade/response/validation'
require 'esplanade/response/error'

module Esplanade
  class Response
    attr_reader :request

    def initialize(request, status, raw_body)
      @request = request
      @status = status
      @raw_body = raw_body
    end

    def doc
      @doc ||= Doc.new(@request, raw)
    end

    def raw
      @raw ||= Raw.new(@request, @status, @raw_body)
    end

    def validation
      @validation ||= Validation.new(@request, doc, raw)
    end
  end
end
