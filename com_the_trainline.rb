require_relative "./parser.rb"
require "rest-client"
require "json"

class ComTheTrainline
  BASE_URL = "https://www.thetrainline.com/api/journey-search/"

  # @param [String] from, the from location
  # @param [String] to, the to location
  # @param [String] departure_at, the time to leave
  #
  # @return [Array<Hash>|nil] Either the resulting segments or nil on failure
  def self.find(from, to, departure_at)
    payload = {
      transitDefinitions: [
        {
          direction: "outward",
          origin: from,
          destination: to,
          journeyDate: {
            type: "departAfter",
            time: departure_at
          }
        }]
    }

    response = RestClient.post(BASE_URL, payload.to_json, headers)

    if response.code == 200
      Parser.new(response).build_segments
    else
      puts "HTTP Error: #{response.code}"
      nil
    end
  end
end
