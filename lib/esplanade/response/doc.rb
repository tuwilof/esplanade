module Esplanade
  class Response
    class Doc
      def initialize(request, raw)
        @request = request
        @raw = raw
      end

      def tomogram
        @tomogram ||= @request.doc.responses.find_all { |response| response['status'] == @raw.status }
        return @tomogram unless @tomogram == []
        raise NotDocumented, not_documented
      rescue NoMethodError
        raise DocResponseError
      end

      def json_schemas
        @json_schemas ||= tomogram.map { |action| action['body'] }
        return @json_schemas if @json_schemas != [] && @json_schemas.all? { |json_schema| json_schema != {} }
        raise ResponseDocWithoutJsonSchemas, without_json_schemas
      end

      def status
        @status ||= tomogram['status']
      end

      private

      def not_documented
        {
          request: {
            method: @request.raw.method,
            path: @request.raw.path
          },
          status: @raw.status
        }
      end

      def without_json_schemas
        {
          request: {
            method: @request.raw.method,
            path: @request.raw.path
          },
          status: status
        }
      end
    end
  end
end
