require 'rails_helper'

RSpec.describe "Properties API", type: :request do
  let!(:nearby_property) { create(:property, lat: 52.5345000, lng: 13.4240000, property_type: "apartment", offer_type: "sell") }
  let!(:far_property) { create(:property, lat: 52.6000000, lng: 13.5000000, property_type: "apartment", offer_type: "sell") }

  let(:valid_params) do
    { lat: 52.5342963, lng: 13.4236807, property_type: "apartment", marketing_type: "sell" }
  end

  subject(:make_request) { get "/properties/nearby", params: request_params }

  shared_examples "returns error message" do |message|
    it "returns an error message" do
      make_request
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include(message)
    end
  end

  describe "GET /properties/nearby" do
    context "with valid parameters" do
      let(:request_params) { valid_params }

      it "returns properties only within 5km" do
        make_request
        json_response = JSON.parse(response.body)
        expect(json_response["properties"].pluck("id")).to include(nearby_property.id)
        expect(json_response["properties"].pluck("id")).not_to include(far_property.id)
      end
    end

    context "with invalid parameters" do
      context "when latitude or longitude is missing" do
        let(:request_params) { { property_type: "apartment", marketing_type: "sell" } }
        include_examples "returns error message", "Lat is required"
        include_examples "returns error message", "Lng is required"
      end

      context "when latitude/longitude values are invalid" do
        let(:request_params) { { lat: '-14444.2', lng: '20004443.4', property_type: "apartment", marketing_type: "sell" } }
        include_examples "returns error message", "Coordinates must be within Germany's borders."
      end

      context "when property_type or marketing_type is invalid" do
        let(:request_params) { valid_params.merge(property_type: "villa", marketing_type: "lease") }
        include_examples "returns error message", "Property type invalid. Must be either 'apartment' or 'single_family_house'."
        include_examples "returns error message", "Offer type invalid. Must be either 'rent' or 'sell'."
      end
    end

    context "when properties are outside the search radius" do
      let(:request_params) { { lat: 52.400000, lng: 13.100000, property_type: "apartment", marketing_type: "sell" } }

      it "returns a message when no properties are found" do
        make_request
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("No properties found within 5 km radius.")
      end
    end

    context "when latitude/longitude are out of Germany's borders" do
      let(:request_params) { { lat: 60.0000, lng: 20.0000, property_type: "apartment", marketing_type: "sell" } }
      include_examples "returns error message", "Coordinates must be within Germany's borders."
    end
  end
end
