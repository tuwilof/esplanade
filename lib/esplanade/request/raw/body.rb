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
          @string ||= @env['rack.request.form_vars']
        rescue NoMethodError
          raise RawRequestError
        end

        def to_hash
          @hash ||= MultiJson.load(to_string)
        rescue MultiJson::ParseError
          raise RequestBodyIsNotJson,
                method: @raw_request.method,
                path: @raw_request.path,
                body: to_string
        end
      end
    end
  end
end
