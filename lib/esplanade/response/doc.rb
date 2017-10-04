module Esplanade
  class Response
    class Doc
      def initialize(request, raw_status)
        @request = request
        @raw_status = raw_status
      end

      def tomogram
        @tomogram ||= @request.doc.responses.find do |response|
                        response['status'] == @raw_status
                      end
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
        @json_schemas ||= if tomogram
                            tomogram.map { |action| action['body'] }
                          end
      end

      def status
        @status ||= tomogram['status']
      end

      def present?
        @present ||= tomogram != [] && !tomogram.nil?
      end

      def json_schemas?
        @has_json_schemas ||=
          json_schemas &&
          json_schemas != [] &&
          json_schemas.all? { |json_schema| json_schema != {} }
      end
    end
  end
end
