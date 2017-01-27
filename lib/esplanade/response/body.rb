module Esplanade
  class Response
    class Body < Hash
      class << self
        private_class_method :new

        def craft(body)
          # According to specification Rack http://rack.github.io
          # body can only answer each
          lines = []
          body.each { |line| lines.push(line) }
          lines_to_json(lines)
        end

        private

        def lines_to_json(lines)
          if lines.join.empty?
            {}
          else
            res = lines.join('\n')
            begin
              MultiJson.load(res)
            rescue MultiJson::ParseError
              res
            end
          end
        end
      end
    end
  end
end
