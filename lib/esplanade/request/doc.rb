module Esplanade
  class Request
    class Doc
      def initialize(main_documentation, raw)
        @main_documentation = main_documentation
        @raw = raw
      end

      def tomogram
        raise PrefixNotMatch.new(**message) unless @main_documentation.prefix_match?(@raw.path)

        @tomogram = @main_documentation.find_request_with_content_type(
          method: @raw.method,
          path: @raw.path,
          content_type: @raw.content_type
        )
        raise NotDocumented.new(**message) if @tomogram.nil?

        @tomogram
      end

      def json_schema
        @json_schema ||= tomogram.request
      end

      def method
        @method ||= tomogram.method
      end

      def path
        @path ||= tomogram.path.to_s
      end

      def content_type
        @content_type ||= tomogram.content_type.to_s
      end

      def responses
        @responses ||= tomogram.responses
      rescue NotDocumented
        []
      end

      private

      def message
        {
          method: @raw.method,
          path: @raw.path,
          raw_path: @raw.raw_path,
          content_type: @raw.content_type
        }
      end
    end
  end
end
