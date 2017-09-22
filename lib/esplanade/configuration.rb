module Esplanade
  class Configuration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :prefix

    def initialize
      @prefix = ''
    end
  end
end
