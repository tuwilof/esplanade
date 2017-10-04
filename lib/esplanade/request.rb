require 'esplanade/request/doc'
require 'esplanade/request/raw'
require 'esplanade/request/validation'

module Esplanade
  class Request
    def initialize(documentation, env)
      @documentation = documentation
      @env = env
    end

    def doc
      @doc ||= Doc.new(@documentation, raw)
    end

    def raw
      @raw ||= Raw.new(@env)
    end

    def validation
      @validation || Validation.new(doc, raw)
    end
  end
end
