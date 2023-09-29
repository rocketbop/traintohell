require "json"
require "date"

class Parser
  attr_reader :search_response, :data

  def initialize(search_response)
    @search_response = search_response
    @data = JSON.parse(search_response)["data"]
  end

  def build_segments
    journey_search = data["journeySearch"]
    legs_data = journey_search["legs"]
    data["journeySearch"]["journeys"].to_a.map do |segment|
      segment_data = segment[1]
      first_leg_id = segment_data["legs"].first
      last_leg_id = segment_data["legs"].last
      first_leg = legs_data[first_leg_id]
      last_leg = legs_data[last_leg_id]
      first_leg_departure_location_id = first_leg["departureLocation"]
      last_leg_arrival_location_id = last_leg["arrivalLocation"]
      departure_location = data["locations"][first_leg_departure_location_id]
      arrival_location = data["locations"][last_leg_arrival_location_id]

      transport_modes = data["transportModes"]
      legs = segment_data["legs"].map { |leg_id| legs_data[leg_id]}
      products = legs.map {|leg| transport_modes[leg["transportMode"]]["mode"]}.uniq
      alternative_ids = journey_search["sections"].reduce([]) { |acc, section| alternative = section[1]["alternatives"]; acc.concat(alternative) unless alternative.empty?; acc}
      fare_ids = journey_search["alternatives"].map { |alternative| alternative[1]["fares"]}.flatten.uniq
      fares = fare_ids.map { |fare_id| journey_search["fares"][fare_id] }
      {
        departure_station: departure_location["name"],
        departure_at: DateTime.parse(segment[1]["departAt"]),
        arrival_station: arrival_location["name"],
        arrival_at: DateTime.parse(segment[1]["arriveAt"]),
        duration_in_minutes: segment_data["duration"].scan(/\d+/).join,
        changeovers: segment_data["legs"].count - 1,
        products: products,
        fares: fares.map { |fare| build_fare(fare) }

      }
    end
  end

  private

  def build_fare(fare_data)
    fare_type = data["fareTypes"][fare_data["fareType"]]
    {
      name: fare_type["name"],
      price_in_cents: (fare_data["fullPrice"]["amount"] * 100).to_i,
      currency: fare_data["fullPrice"]["currencyCode"],
      comfort_class: fare_data["fareLegs"].find { |leg| leg["travelClass"] != nil}["travelClass"]["name"]
    }
  end

end
