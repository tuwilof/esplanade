require 'multi_json'

module Esplanade
  class Request
    class Raw
      class Body
        def initialize(raw_request, env)
          @raw_request = raw_request
          @env = env
        end

        def to_string
          @string ||= @env['rack.input'].read
        end

        def to_hash
          @hash ||= if to_string.nil?
                      {}
                    else
                      MultiJson.load(to_string)
                    end
        rescue MultiJson::ParseError
          raise BodyIsNotJson, message
        end

        private

        def message
          {
            method: @raw_request.method,
            path: @raw_request.path,
            body: to_string
          }
        end
      end
    end
  end
end
