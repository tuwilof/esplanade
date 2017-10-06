require 'json-schema'

module Esplanade
  class Response
    class Validation
      def initialize(request, doc, raw)
        @request = request
        @doc = doc
        @raw = raw
      end

      def valid!
        @error ||= if @doc.json_schemas.size == 1
                     one_json_schema
                   else
                     more_than_one_json_schema
                   end
        raise Invalid, message if @error != []
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

      def message
        {
          request: {
            method: @request.raw.method,
            path: @request.raw.path
          },
          status: @raw.status,
          body: @raw.body.to_string,
          error: @error
        }
      end
    end
  end
end
