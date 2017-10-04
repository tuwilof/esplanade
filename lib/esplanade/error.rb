module Esplanade
  class Error < RuntimeError; end

  class DocRequestError  < Error; end
  class DocResponseError < Error; end
  class RawRequestError  < Error; end
  class RawResponseError < Error; end

  class RequestNotDocumented        < Error; end
  class DocRequestWithoutJsonSchema < Error; end
  class RequestBodyIsNotJson        < Error; end
  class RequestInvalid              < Error; end

  class ResponseNotDocumented < Error; end
  class ResponseBodyIsNotJson < Error; end
end
