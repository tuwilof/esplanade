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
      @body ||= Esplanade::Response::Body.new(@raw_body)
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
      return nil unless body
      return nil unless body.to_h
      return @error = JSON::Validator.fully_validate(json_schemas.first, body.to_h) if json_schemas.size == 1

      json_schemas.each do |json_schema|
        res = JSON::Validator.fully_validate(json_schema, body.to_h)
        return @error = res if res == []
      end

      @error = ['invalid']
    end

    def documented?
      @documented ||= documentation != [] && !documentation.nil?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
