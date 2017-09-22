module Esplanade
  class Response
    class Body < Hash
      def initialize(body)
        @body = body
      end

      def to_s
        @to_s ||= begin
                    @body.inject([]) { |lines, line| lines.push(line) }.join('\n')
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
