require 'json-schema'
require 'esplanade/error'

module Esplanade
  class Request
    class Validation
      def initialize(raw, doc)
        @raw = raw
        @doc = doc
      end

      def error
        @error ||= if @doc.json_schema
                     JSON::Validator.fully_validate(@doc.json_schema, @raw.body.to_hash)
                   end
      end

      def valid?
        @valid ||= error == []
      end

      def valid!
        return if error == []
        raise RequestInvalid, method: @raw.method,
                              path: @raw.path,
                              body: @raw.body.to_string,
                              error: error
      end
    end
  end
end
