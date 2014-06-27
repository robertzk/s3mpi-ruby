require 'json'

module S3MPI
  module Format

    def parse_json_allowing_quirks_mode obj
      JSON.parse(obj || 'null')
    rescue JSON::ParserError => e
      JSON.parse(obj || 'null', quirks_mode: true)
    end

  end
end

