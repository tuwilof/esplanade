module Esplanade
  class Response
    class Doc
      def initialize(request, raw)
        @request = request
        @raw = raw
      end

      def tomogram
        @tomogram ||= @request.doc.responses.find_all { |response| response['status'] == @raw.status }
        raise NotDocumented, message if @tomogram == []

        @tomogram
      end

      def json_schemas
        @json_schemas ||= tomogram.map { |action| action['body'] }
      end

      def status
        @status ||= tomogram['status']
      end

      private

      def message
        {
          request: {
            method: @request.raw.method,
            path: @request.raw.path
          },
          status: @raw.status
        }
      end
    end
  end
end
