FactoryBot.define do
  factory :property do
    house_number { "31" }
    street { "Marienburger Straße" }
    city { "Berlin" }
    zip_code { "10405" }
    lat { 52.5342963 }
    lng { 13.4236807 }
    price { 350000 }
    property_type { "apartment" }
    offer_type { "sell" }
  end
end
