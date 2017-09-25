module Esplanade
  class Response
    class Body
      def initialize(body)
        @body = body
      end

      def to_s
        @to_s ||= string_and_received[0]
      end

      def to_h
        @to_h ||= hash_and_parsed[0]
      end

      def received?
        @received ||= string_and_received[1]
      end

      def parsed?
        @parsed ||= hash_and_parsed[1]
      end

      def string_and_received
        @string_and_received ||= begin
          [@body.join, true]
        rescue
          ['', false]
        end
      end

      def hash_and_parsed
        @hash_and_parsed ||= begin
          [MultiJson.load(to_s), true]
        rescue MultiJson::ParseError
          [{}, false]
        end
      end
    end
  end
end
