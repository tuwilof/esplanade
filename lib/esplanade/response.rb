require 'esplanade/response/raw'
require 'esplanade/response/doc'
require 'esplanade/response/validation'

module Esplanade
  class Response
    attr_reader :request

    def initialize(request, status, raw_body)
      @request = request
      @status = status
      @raw_body = raw_body
    end

    def raw
      @raw ||= Esplanade::Response::Raw.new(@request, @status, @raw_body)
    end

    def doc
      @doc ||= Esplanade::Response::Doc.new(@request, @status)
    end

    def validation
      @validation ||= Esplanade::Response::Validation.new(@request, raw, doc)
    end
  end
end
