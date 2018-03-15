require 'json-schema'
require 'esplanade/error'

module Esplanade
  class Request
    class Validation
      def initialize(doc, raw)
        @doc = doc
        @raw = raw
      end

      def valid!
        raise ContentTypeIsNotJson, message unless @doc.content_type  == 'application/json'
        @error ||= JSON::Validator.fully_validate(@doc.json_schema, @raw.body.to_hash)

        raise Invalid, message unless @error.empty?
      end

      private

      def message
        {
          method: @raw.method,
          path:   @raw.path,
          content_type: @raw.content_type,
          body:   @raw.body.to_string,
          error:  @error
        }
      end
    end
  end
end
