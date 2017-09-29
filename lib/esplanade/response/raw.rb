require 'esplanade/response/raw/body'

module Esplanade
  class Response
    class Raw
      attr_reader :status

      def initialize(status, raw_body)
        @status = status
        @raw_body = raw_body
      end

      def body
        @body ||= Esplanade::Response::Raw::Body.new(@raw_body)
      end
    end
  end
end
