require 'esplanade/response/raw/body'

module Esplanade
  class Response
    class Raw
      def initialize(request, raw_status, raw_body)
        @request = request
        @raw_status = raw_status
        @raw_body = raw_body
      end

      def status
        @status ||= @raw_status.to_s
      end

      def body
        @body ||= Body.new(@request, self, @raw_body)
      end
    end
  end
end
