require 'multi_json'

module Esplanade
  class Response
    class Raw
      class Body
        def initialize(request, raw_response, raw_body)
          @request = request
          @raw_response = raw_response
          @raw_body = raw_body
        end

        def to_string
          @string ||= @raw_body.first
        rescue NoMethodError
          raise RawResponseError
        end

        def to_hash
          @hash ||= MultiJson.load(to_string)
        rescue MultiJson::ParseError
          raise ResponseBodyIsNotJson,
            request: {
              method: @request.raw.method,
              path: @request.raw.path
            },
            status: @raw_response.status,
            body: @raw_response.body.to_string
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
            [@raw_body.first, true]
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
