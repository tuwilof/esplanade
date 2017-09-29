require 'json-schema'

module Esplanade
  class Request
    class Validation
      def initialize(raw, doc)
        @raw = raw
        @doc = doc
      end

      def error
        @error ||= if doc.json_schema
          JSON::Validator.fully_validate(doc.json_schema, raw.body.to_h)
        end
      end

      def valid?
        @valid ||= error == []
      end
    end
  end
end
