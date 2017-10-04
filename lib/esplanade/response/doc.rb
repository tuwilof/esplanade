module Esplanade
  class Response
    class Doc
      def initialize(request, raw_status)
        @request = request
        @raw_status = raw_status
      end

      def tomogram
        @tomogram ||= @request.doc.responses.find { |response| response['status'] == @raw_status }
        return @tomogram unless @tomogram.nil?
        raise ResponseNotDocumented,
              request: {
                method: @request.raw.method,
                path: @request.raw.path
              },
              status: @raw_status
      rescue NoMethodError
        raise DocResponseError
      end

      def json_schemas
        @json_schemas ||= tomogram.map { |action| action['body'] }
        return @json_schemas if @json_schemas != [] && @json_schemas.all? { |json_schema| json_schema != {} }
        raise DocResponseWithoutJsonSchemas,
              request: {
                method: @request.raw.method,
                path: @request.raw.path
              },
              status: status
      rescue NoMethodError
        raise DocResponseError
      end

      def status
        @status ||= tomogram['status']
      end
    end
  end
end
