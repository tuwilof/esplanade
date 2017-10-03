module Esplanade
  class Request
    class Raw
      class Body
        def initialize(raw_request, env)
          @raw_request = raw_request
          @env = env
        end

        def to_s!
          @env['rack.request.form_vars']
        rescue NoMethodError
          raise CanNotGetBodyOfRequest
        end

        def to_h!
          MultiJson.load(to_s!)
        rescue MultiJson::ParseError
          raise CanNotParseBodyOfRequest,
                "{:method=>\"#{@raw_request.method}\", :path=>\"#{@raw_request.path}\", :body=>\"#{to_s!}\"}"
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
            [@env['rack.request.form_vars'], true]
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
