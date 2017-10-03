module Esplanade
  class Error < RuntimeError; end
  class RequestInvalid < Error; end
  class CanNotGetBodyOfRequest < Error; end
  class CanNotParseBodyOfRequest < Error; end
end
