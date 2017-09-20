require 'json-schema'
require 'esplanade/response/body'

module Esplanade
  class Response
    attr_reader :status

    def initialize(status, raw_body, expect_request)
      @status = status
      @raw_body = raw_body
      @expect_request = expect_request
    end

    def body
      @body ||= Esplanade::Response::Body.craft(@raw_body)
    end

    def schemas
      @schemas ||= @expect_request.schema.find_responses(status: @status)
    end

    def error
      return JSON::Validator.fully_validate(schemas.first['body'], body) if schemas.size == 1

      schemas.each do |action|
        res = JSON::Validator.fully_validate(action['body'], body)
        return res if res == []
      end

      ['invalid']
    end

    def documented?
      @documented ||= !schemas.nil?
    end

    def valid?
      @valid ||= error == []
    end
  end
end
