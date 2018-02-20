module Esplanade
  class Request
    class Error < Esplanade::Error; end

    class PrefixNotMatch < Error; end
    class NotDocumented  < Error; end
    class BodyIsNotJson  < Error; end

    class Invalid < Error
      attr_reader :method, :path, :body, :error

      def initialize(method:, path:, body:, error:)
        @method = method
        @path   = path
        @body   = body
        @error  = error

        super(to_hash)
      end

      def to_hash
        {
          method: @method,
          path:   @path,
          body:   @body,
          error:  @error
        }
      end
    end
  end
end
