module Esplanade
  class Error < RuntimeError; end

  class DocError         < Error; end
  class RawRequestError  < Error; end
  class RawResponseError < Error; end

  class RequestNotDocumented        < Error; end
  class DocRequestWithoutJsonSchema < Error; end
  class RequestBodyIsNotJson        < Error; end
  class RequestInvalid              < Error; end
end