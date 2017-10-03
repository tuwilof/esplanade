module Esplanade
  class Error < RuntimeError; end
  class RequestInvalid < Error; end

  class RawRequestError < Error; end
  class CanNotParseBodyOfRequest < Error; end

  class DocError < Error; end
  class RequestDoesNotHaveJsonSchemas < Error; end
end
