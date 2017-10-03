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
      @raw ||= Esplanade::Response::Raw.new(@request,@status, @raw_body)
    end

    def doc
      @doc ||= Esplanade::Response::Doc.new(@status, @request)
    end

    def validation
      @validation ||= Esplanade::Response::Validation.new(raw, doc)
    end
  end
end
