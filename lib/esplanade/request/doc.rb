module Esplanade
  class Request
    class Doc
      def initialize(main_documentation, raw)
        @main_documentation = main_documentation
        @raw = raw
      end

      def tomogram
        @tomogram ||= @main_documentation.find_request(method: @raw.method, path: @raw.path)
        if @tomogram.nil?
          raise Esplanade::RequestNotDocumented,
                method: @raw.method,
                path: @raw.path
        end
        @tomogram
      rescue NoMethodError
        raise DocError
      end

      def json_schema
        @json_schema ||= tomogram.request
        if @json_schema == {}
          raise Esplanade::DocRequestWithoutJsonSchema,
            method: @raw.method,
            path: @raw.path
        end
        @json_schema
      rescue NoMethodError
        raise DocError
      end

      def method
        @method ||= tomogram.method
      rescue ArgumentError
        raise DocError
      end

      def path
        @path ||= tomogram.path.to_s
      rescue NoMethodError
        raise DocError
      end

      def responses
        @responses ||= tomogram.responses
      rescue NoMethodError
        raise DocError
      end
    end
  end
end
