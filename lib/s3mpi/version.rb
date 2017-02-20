module S3MPI
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = 1

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.');
  end
end
