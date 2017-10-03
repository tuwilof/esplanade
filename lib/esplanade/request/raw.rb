require 'esplanade/request/raw/body'

module Esplanade
  class Request
    class Raw
      def initialize(env)
        @env = env
      end

      def method
        @method ||= @env['REQUEST_METHOD']
      rescue NoMethodError
        raise RawRequestError
      end

      def path
        @path ||= @env['PATH_INFO']
      rescue NoMethodError
        raise RawRequestError
      end

      def body
        @body ||= Esplanade::Request::Raw::Body.new(self, @env)
      end
    end
  end
end
