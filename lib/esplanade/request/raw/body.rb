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
          return @string if @string

          @string = @env['rack.input'].read
          @env['rack.input'].rewind
          @string
        end

        def to_hash
          @hash ||= MultiJson.load(to_string)
        rescue MultiJson::ParseError
          raise BodyIsNotJson.new(**message)
        end

        def reduced_version
          @reduced_version ||= if to_string && to_string.size >= 1000
                                 "#{to_string[0..499]}...#{to_string[500..-1]}"
                               else
                                 to_string
                               end
        end

        private

        def message
          {
            method: @raw_request.method,
            path: @raw_request.path,
            content_type: @raw_request.content_type,
            body: reduced_version
          }
        end
      end
    end
  end
end
