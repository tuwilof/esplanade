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
      @doc ||= Esplanade::Request::Doc.new(@main_documentation, raw)
    end

    def raw
      @raw ||= Esplanade::Request::Raw.new(@env)
    end

    def validation
      @validation || Esplanade::Request::Validation.new(doc, raw)
    end
  end
end
