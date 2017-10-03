module Esplanade
  class Response
    class Doc
      def initialize(request, raw_status)
        @request = request
        @raw_status = raw_status
      end

      def status
        @status ||= tomogram['status']
      end

      def tomogram
        @tomogram ||= if @request.doc.responses
                        @request.doc.responses.find do |response|
                          response['status'] == @raw_status
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
