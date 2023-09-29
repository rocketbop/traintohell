require_relative "./../parser.rb"
require "pry-byebug"
require "date"

RSpec.describe Parser do
  subject(:parser) { described_class.new(response) }
  let(:response) { File.read("spec/fixtures/stub.json")}

  describe "#build_segments" do
    subject(:segments) { parser.build_segments }

    let(:expected_segments) do
      [
        {
          departure_station: "London Euston",
          departure_at: DateTime.parse("2023-10-21T11:01:00+01:00"),
          arrival_station: "London Kings Cross",
          arrival_at: DateTime.parse("2023-10-21T11:41:00+01:00"),
          duration_in_minutes: "40",
          changeovers: 2,
          products: ["rapidTransit", "train"],
          fares: [
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            }
          ]
        },
        {
          departure_station: "London Euston",
          departure_at: DateTime.parse("2023-10-21T11:16:00+01:00"),
          arrival_station: "London Kings Cross",
          arrival_at: DateTime.parse("2023-10-21T11:43:00+01:00"),
          duration_in_minutes: "27",
          changeovers: 1,
          products: ["rapidTransit", "train"],
          fares: [
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            }
          ]
        },
        {
          departure_station: "London Euston",
          departure_at: DateTime.parse("2023-10-21T11:23:00+01:00"),
          arrival_station: "London Kings Cross",
          arrival_at: DateTime.parse("2023-10-21T11:50:00+01:00"),
          duration_in_minutes: "27",
          changeovers: 1,
          products: ["rapidTransit", "train"],
          fares: [
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            }
          ]
        },
        {
          departure_station: "London Euston",
          departure_at: DateTime.parse("2023-10-21T11:24:00+01:00"),
          arrival_station: "London Kings Cross",
          arrival_at: DateTime.parse("2023-10-21T12:10:00+01:00"),
          duration_in_minutes: "46",
          changeovers: 2,
          products: ["rapidTransit", "train"],
          fares: [
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            },
            {
              name: "Anytime Day Single",
              price_in_cents: 813,
              currency: "EUR",
              comfort_class: "Standard"
            }
          ]
        }
      ]
    end

    it "builds up the expected hash" do
      expect(segments).to eq(expected_segments)
    end
  end
end
