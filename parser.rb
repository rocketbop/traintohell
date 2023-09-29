require "json"
require "date"

class Parser
  attr_reader :data, :journey_search, :legs_data, :transport_modes

  def initialize(search_response)
    @data = JSON.parse(search_response)["data"]
    @journey_search = data["journeySearch"]
    @legs_data = journey_search["legs"]
    @transport_modes = data["transportModes"]
  end

  def build_segments
    data["journeySearch"]["journeys"].map do |segment|
      build_segment(segment)
    end
  end

  def build_segment(segment)
      segment_data = segment[1]
      legs = segment_data["legs"].map { |leg_id| legs_data[leg_id]}
      departure_location = data["locations"][legs.first["departureLocation"]]
      arrival_location = data["locations"][legs.last["arrivalLocation"]]

      products = legs.map {|leg| transport_modes[leg["transportMode"]]["mode"]}.uniq
      binding.pry
      fares = build_fare_data
      {
        departure_station: departure_location["name"],
        departure_at: DateTime.parse(segment[1]["departAt"]),
        arrival_station: arrival_location["name"],
        arrival_at: DateTime.parse(segment[1]["arriveAt"]),
        duration_in_minutes: segment_data["duration"].scan(/\d+/).join,
        changeovers: segment_data["legs"].count - 1,
        products: products,
        fares: fares.map { |fare| build_segment_fare(fare) }

      }
  end

  def build_fare_data
    alternative_ids = journey_search["sections"].reduce([]) do |acc, section|
      alternative = section[1]["alternatives"]; acc.concat(alternative) unless alternative.empty?; acc
    end

    fare_ids = journey_search["alternatives"].map { |alternative| alternative[1]["fares"]}.flatten.uniq
    fares = fare_ids.map { |fare_id| journey_search["fares"][fare_id] }
  end

  private

  def build_segment_fare(fare_data)
    fare_type = data["fareTypes"][fare_data["fareType"]]
    {
      name: fare_type["name"],
      price_in_cents: (fare_data["fullPrice"]["amount"] * 100).to_i,
      currency: fare_data["fullPrice"]["currencyCode"],
      comfort_class: fare_data["fareLegs"].find { |leg| leg["travelClass"] != nil}["travelClass"]["name"]
    }
  end
end
