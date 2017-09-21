require 'json-schema'
require 'esplanade/response/body'

module Esplanade
  class Response
    attr_reader :status, :request

    def initialize(status, raw_body, request)
      @status = status
      @raw_body = raw_body
      @request = request
    end

    def body
      @body ||= Esplanade::Response::Body.craft(@raw_body)
    end

    def response_tomograms
      @response_tomograms ||= if @request && @request.request_tomogram
                                @request.request_tomogram.find_responses(status: @status)
                              end
    end

    def json_schemas
      @json_schemas ||= if response_tomograms
                          response_tomograms.map { |action| action['body'] }
                        end
    end

    def error
      return @error if @error
      return nil unless json_schemas
      return nil unless body
      return @error = JSON::Validator.fully_validate(json_schemas.first, body) if json_schemas.size == 1

      json_schemas.each do |json_schema|
        res = JSON::Validator.fully_validate(json_schema, body)
        return @error = res if res == []
      end

      @error = ['invalid']
    end

    def documented?
      @documented ||= !response_tomograms.nil?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
