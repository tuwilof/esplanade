module Esplanade
  class Request
    class Error
      def self.unsuitable(message)
        status = '400'
        headers = { 'Content-Type' => 'application/json; charset=utf-8' }
        body = [MultiJson.dump(error: [message[2..-3]])]
        [status, headers, body]
      end

      def self.not_documented
        status = '400'
        headers = { 'Content-Type' => 'application/json; charset=utf-8' }
        body = [MultiJson.dump(error: ['Not documented'])]
        [status, headers, body]
      end
    end
  end
end
