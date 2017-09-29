module Esplanade
  class Response
    class Doc
      attr_reader :status

      def initialize(status, request)
        @status = status
        @request = request
      end

      def tomogram
        @tomogram ||= if @request.doc.responses
                        @request.doc.responses.find do |response|
                          response['status'] == @status
                        end
                      end
      end

      def json_schemas
        @json_schemas ||= if tomogram
                            tomogram.map { |action| action['body'] }
                          end
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
