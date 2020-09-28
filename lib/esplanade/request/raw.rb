require 'esplanade/request/raw/body'

module Esplanade
  class Request
    class Raw
      def initialize(env)
        @env = env
      end

      def method
        @method ||= @env['REQUEST_METHOD']
      end

      def path
        @path ||= @env['PATH_INFO']
      end

      def body
        @body ||= Body.new(self, @env)
      end

      def content_type
        @content_type ||= @env['CONTENT_TYPE'].to_s.split(';').first
      end
    end
  end
end
