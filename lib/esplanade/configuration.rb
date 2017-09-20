module Esplanade
  class Configuration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :prefix,
                  :skip_not_documented,
                  :validation_requests,
                  :validation_response

    def initialize
      @prefix = ''
      @skip_not_documented = true
      @validation_requests = true
      @validation_response = true
    end
  end
end
