require 'json-schema'

module Esplanade
  class Response
    attr_accessor :status, :body, :schemas

    class Unsuitable < RuntimeError; end
    class NotDocumented < RuntimeError; end

    def initialize(status, body, expect_request)
      return unless Esplanade.configuration.validation_response && expect_request
      @status = status
      @body = Body.craft(body)
      @schemas = expect_request.find_responses(status: @status)
      raise NotDocumented unless (@schemas&.first) || Esplanade.configuration.skip_not_documented
      self
    end

    def error
      return JSON::Validator.fully_validate(@schemas.first['body'], @body) if @schemas.size == 1

      @schemas.each do |action|
        res = JSON::Validator.fully_validate(action['body'], @body)
        return res if res == []
      end

      ['invalid']
    end

    def valid!
      raise Unsuitable, error unless error.empty?
    end

    def validate?
      @schemas&.first && Esplanade.configuration.validation_response
    end
  end
end
