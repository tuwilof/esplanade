require 'esplanade/response/raw/body'

module Esplanade
  class Response
    class Raw
      def initialize(raw_status, raw_body)
        @raw_status = raw_status
        @raw_body = raw_body
      end

      def status
        @status ||= @raw_status.to_s
      end

      def body
        @body ||= Esplanade::Response::Raw::Body.new(@raw_body)
      end
    end
  end
end
