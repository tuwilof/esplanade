module Esplanade
  class Request
    class Body
      def initialize(env)
        @env = env
      end

      def to_s
        @to_s ||= begin
          @env['rack.input'].read
        rescue
          ''
        end
      end

      def hash_and_parsed
        @hash_and_parsed ||= begin
          [MultiJson.load(to_s), true]
        rescue MultiJson::ParseError
          [{}, false]
        end
      end

      def to_h
        @to_h ||= hash_and_parsed[0]
      end

      def parsed?
        @parsed ||= hash_and_parsed[1]
      end
    end
  end
end
