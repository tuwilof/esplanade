module Esplanade
  class Request
    class Error < Esplanade::Error; end

    class PrefixNotMatch < Error; end

    class NotDocumented < Error
      def initialize(method:, path:, raw_path:, content_type:)
        @method = method
        @path = path
        @raw_path = raw_path
        @content_type = content_type

        super(to_hash)
      end

      def to_hash
        {
          method: @method,
          path: @path,
          raw_path: @raw_path,
          content_type: @content_type
        }
      end
    end

    class ContentTypeIsNotJson < Error
      def initialize(method:, path:, raw_path:, content_type:)
        @method = method
        @raw_path = raw_path
        @path = path
        @content_type = content_type

        super(to_hash)
      end

      def to_hash
        {
          method: @method,
          path: @path,
          raw_path: @raw_path,
          content_type: @content_type
        }
      end
    end

    class BodyIsNotJson < Error
      def initialize(method:, path:, raw_path:, content_type:, body:)
        @method = method
        @path = path
        @raw_path = raw_path
        @content_type = content_type
        @body = body

        super(to_hash)
      end

      def to_hash
        {
          method: @method,
          path: @path,
          raw_path: @raw_path,
          content_type: @content_type,
          body: @body
        }
      end
    end

    class Invalid < Error
      def initialize(method:, path:, raw_path:, content_type:, body:, error:)
        @method = method
        @path = path
        @raw_path = raw_path
        @content_type = content_type
        @body = body
        @error = error

        super(to_hash)
      end

      def to_hash
        {
          method: @method,
          path: @path,
          raw_path: @raw_path,
          content_type: @content_type,
          body: @body,
          error: @error
        }
      end
    end
  end
end
