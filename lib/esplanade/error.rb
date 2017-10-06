module Esplanade
  class Error < RuntimeError; end

  class DocRequestError  < Error; end
  class DocResponseError < Error; end
  class RawRequestError  < Error; end
  class RawResponseError < Error; end

  class RequestDocWithoutJsonSchema < Error; end

  class ResponseDocWithoutJsonSchemas < Error; end
end
