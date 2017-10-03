require 'esplanade/request/raw'
require 'esplanade/request/doc'
require 'esplanade/request/validation'

module Esplanade
  class Request
    def initialize(env, main_documentation)
      @env = env
      @main_documentation = main_documentation
    end

    def raw
      @raw ||= Esplanade::Request::Raw.new(@env)
    end

    def doc
      @doc ||= Esplanade::Request::Doc.new(@main_documentation, raw)
    end

    def validation
      @validation || Esplanade::Request::Validation.new(doc, raw)
    end
  end
end
