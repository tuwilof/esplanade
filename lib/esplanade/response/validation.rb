require 'json-schema'

module Esplanade
  class Response
    class Validation
      def initialize(raw, doc)
        @raw = raw
        @doc = doc
      end

      def error
        @error ||= if @doc.json_schemas? && @raw.json?
                     if @doc.json_schemas.size == 1
                       one_json_schema
                     else
                       more_than_one_json_schema
                     end
                   end
      end

      def valid?
        @valid ||= error == []
      end

      private

      def one_json_schema
        JSON::Validator.fully_validate(@doc.json_schemas.first, @raw.body.to_h)
      end

      def more_than_one_json_schema
        main_res = @doc.json_schemas.each do |json_schema|
          res = JSON::Validator.fully_validate(json_schema, @raw.body.to_h)
          break res if res == []
        end
        if main_res != []
          ['invalid']
        else
          []
        end
      end
    end
  end
end
