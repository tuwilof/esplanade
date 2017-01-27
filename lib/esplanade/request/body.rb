module Esplanade
  class Request
    class Body < Hash
      private_class_method :new

      def self.craft(env)
        params_string = env['rack.input'].read
        params_hash = {}
        params_hash = MultiJson.load(params_string) unless params_string == ''
        new.merge(params_hash)
      end
    end
  end
end
