module Esplanade
  class Request
    class Doc
      def initialize(main_documentation, raw)
        @main_documentation = main_documentation
        @raw = raw
      end

      def tomogram
        @tomogram ||= @main_documentation.find_request(method: @raw.method, path: @raw.path)
        return @tomogram unless @tomogram.nil?
        raise RequestNotDocumented, not_documented
      rescue NoMethodError
        raise DocRequestError
      end

      def json_schema
        @json_schema ||= tomogram.request
        return @json_schema unless @json_schema == {}
        raise DocRequestWithoutJsonSchema, without_json_schema
      end

      def method
        @method ||= tomogram.method
      end

      def path
        @path ||= tomogram.path.to_s
      end

      def responses
        @responses ||= tomogram.responses
      end

      private

      def not_documented
        {
          method: @raw.method,
          path: @raw.path
        }
      end

      def without_json_schema
        {
          method: method,
          path: path
        }
      end
    end
  end
end
