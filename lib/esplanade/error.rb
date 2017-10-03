module Esplanade
  class Error < RuntimeError; end

  class RawRequestError < Error; end
  class RequestBodyIsNotJson < Error; end

  class DocError < Error; end
  class RequestDoesNotHaveJsonSchemas < Error; end
  class RequestNotDocumented < Error; end

  class RequestInvalid < Error; end
end
