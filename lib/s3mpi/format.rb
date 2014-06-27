require 'json'

module S3MPI
  class Format

    def parse_json_allowing_quirks_mode name
      JSON.parse(obj || 'null')
    rescue JSON::ParserError => e
      JSON.parse(obj || 'null', quirks_mode: true)
    end

  end
end

