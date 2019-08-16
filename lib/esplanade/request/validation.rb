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
        raise ContentTypeIsNotJson, mini_message unless @doc.content_type == 'application/json'

        @error ||= JSON::Validator.fully_validate(@doc.json_schema, @raw.body.to_hash)

        raise Invalid, message unless @error.empty?
      end

      private

      def mini_message
        {
          method: @doc.method,
          path: @doc.path,
          content_type: @doc.content_type
        }
      end

      def message
        {
          method: @raw.method,
          path: @raw.path,
          content_type: @raw.content_type,
          body: @raw.body.to_hash,
          error: @error
        }
      end
    end
  end
end
