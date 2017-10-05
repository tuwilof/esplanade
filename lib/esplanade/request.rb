require 'esplanade/request/doc'
require 'esplanade/request/raw'
require 'esplanade/request/validation'

module Esplanade
  class Request
    class Error < Esplanade::Error; end
    class NotDocumented < Error; end
    class BodyIsNotJson < Error; end
    class Invalid       < Error; end

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
