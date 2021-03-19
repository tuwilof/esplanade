module Esplanade
  class Response
    class Error < Esplanade::Error; end

    class PrefixNotMatch < Error; end

    class NotDocumented < Error
      def initialize(request:, status:)
        @method = request[:method]
        @path = request[:path]
        @raw_path = request[:raw_path]
        @status = status

        super(to_hash)
      end

      def to_hash
        {
          request:
            {
              method: @method,
              path: @path,
              raw_path: @raw_path
            },
          status: @status
        }
      end
    end

    class BodyIsNotJson < Error
      def initialize(request:, status:, body:)
        @method = request[:method]
        @path = request[:path]
        @raw_path = request[:raw_path]
        @status = status
        @body = body

        super(to_hash)
      end

      def to_hash
        {
          request:
            {
              method: @method,
              path: @path,
              raw_path: @raw_path
            },
          status: @status,
          body: @body
        }
      end
    end

    class Invalid < Error
      def initialize(request:, status:, body:, error:)
        @method = request[:method]
        @path = request[:path]
        @raw_path = request[:raw_path]
        @status = status
        @body = body
        @error = error

        super(to_hash)
      end

      def to_hash
        {
          request:
            {
              method: @method,
              path: @path,
              raw_path: @raw_path
            },
          status: @status,
          body: @body,
          error: @error
        }
      end
    end
  end
end
