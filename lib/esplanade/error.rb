module Esplanade
  class Error < RuntimeError; end
  class RequestInvalid < Error; end

  class CanNotGetRequest         < Error; end
  class CanNotGetMethodOfRequest < CanNotGetRequest; end
  class CanNotGetPathOfRequest   < CanNotGetRequest; end
  class CanNotGetBodyOfRequest   < CanNotGetRequest; end
  class CanNotParseBodyOfRequest < Error; end

  class DocRequestSearchError < Error; end
end
