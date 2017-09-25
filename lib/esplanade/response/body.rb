module Esplanade
  class Response
    class Body < Hash
      def initialize(body)
        @body = body
      end

      def to_s
        @to_s ||= begin
                    @body.join
                  rescue
                    ''
                  end
      end

      def to_h
        @to_h ||= hash_and_parsed[0]
      end

      def parsed?
        @parsed ||= hash_and_parsed[1]
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
