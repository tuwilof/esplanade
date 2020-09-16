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
        raise ContentTypeIsNotJson.new(**mini_message) unless @doc.content_type == 'application/json'

        @error ||= if @doc.json_schemas.size == 1
                     one_json_schema
                   else
                     more_than_one_json_schema
                   end

        raise Invalid.new(**message) unless @error.empty?
      end

      private

      def one_json_schema
        JSON::Validator.fully_validate(@doc.json_schemas.first, @raw.body.to_hash)
      end

      def more_than_one_json_schema
        main_res = @doc.json_schemas.each do |json_schema|
          res = JSON::Validator.fully_validate(json_schema, @raw.body.to_hash)
          break res if res == []
        end
        if main_res != []
          ['invalid']
        else
          []
        end
      end

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
