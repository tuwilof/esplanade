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

      def to_h
        @to_h ||= begin
                    MultiJson.load(to_s)
                  rescue MultiJson::ParseError
                    {}
                  end
      end
    end
  end
end
