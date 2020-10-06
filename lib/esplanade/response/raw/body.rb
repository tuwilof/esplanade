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
          @to_string ||= @raw_body.body rescue nil
          @to_string ||= @raw_body.first rescue nil
        end

        def to_hash
          @hash ||= MultiJson.load(to_string)
        rescue MultiJson::ParseError
          raise BodyIsNotJson.new(**message)
        end

        private

        def message
          {
            request: {
              method: @request.raw.method,
              path: @request.raw.path,
              raw_path: @request.raw.raw_path
            },
            status: @raw_response.status,
            body: @raw_response.body.to_string
          }
        end
      end
    end
  end
end
