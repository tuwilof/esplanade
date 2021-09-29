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
          @hash ||= JSON.parse(to_string.to_s)
        rescue JSON::ParserError
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
            raw_path: @raw_request.raw_path,
            content_type: @raw_request.content_type,
            body: reduced_version
          }
        end
      end
    end
  end
end
