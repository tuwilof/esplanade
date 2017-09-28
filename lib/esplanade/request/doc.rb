module Esplanade
  class Request
    class Doc
      def initialize(main_documentation, raw)
        @main_documentation = main_documentation
        @raw = raw
      end

      def tomogram
        @tomogram ||= if @main_documentation
          @main_documentation.find_request(method: @raw.method, path: @raw.path)
        end
      end

      def json_schema
        @json_schema ||= if tomogram
          tomogram.request
        end
      end

      def method
        @method ||= if tomogram
          tomogram.method
        end
      end

      def path
        @path ||= if tomogram
          tomogram.path.to_s
        end
      end

      def responses
        @responses||= if tomogram
          tomogram.responses
        end
      end
    end
  end
end
