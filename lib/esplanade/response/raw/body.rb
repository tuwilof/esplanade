module Esplanade
  class Response
    class Raw
      class Body
        def initialize(body)
          @body = body
        end

        def to_s
          @to_s ||= string_and_received[0]
        end

        def to_h
          @to_h ||= hash_and_json[0]
        end

        def received?
          @received ||= string_and_received[1]
        end

        def json?
          @json ||= hash_and_json[1]
        end

        def string_and_received
          @string_and_received ||= begin
            [@body.join, true]
          rescue
            ['', false]
          end
        end

        def hash_and_json
          @hash_and_json ||= begin
            [MultiJson.load(to_s), true]
          rescue MultiJson::ParseError
            [{}, false]
          end
        end
      end
    end
  end
end
