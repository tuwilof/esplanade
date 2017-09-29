require 'json-schema'

module Esplanade
  class Response
    class Validation
      def initialize(raw, doc)
        @raw = raw
        @doc = doc
      end

      def error
        return @error if @error
        return nil unless @doc.json_schemas
        return nil if @doc.json_schemas == []
        return nil unless @raw.body
        return nil unless @raw.body.to_h
        return @error = JSON::Validator.fully_validate(@doc.json_schemas.first, @raw.body.to_h) if @doc.json_schemas.size == 1

        @doc.json_schemas.each do |json_schema|
          res = JSON::Validator.fully_validate(json_schema, @raw.body.to_h)
          return @error = res if res == []
        end

        @error = ['invalid']
      end

      def valid?
        @valid ||= error == []
      end
    end
  end
end
