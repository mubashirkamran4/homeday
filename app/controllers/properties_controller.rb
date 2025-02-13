class PropertiesController < ApplicationController
  def nearby
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    property_type = params[:property_type]
    marketing_type = params[:marketing_type]

    return render json: { error: "Invalid parameters" }, status: :bad_request if lat.zero? || lng.zero? || property_type.blank? || marketing_type.blank?



    properties = Property
                  .where(property_type: params[:property_type], offer_type: params[:marketing_type])
                  .where("earth_distance(ll_to_earth(?, ?), ll_to_earth(lat, lng)) <= ?", params[:lat], params[:lng], 5000).to_a

    if properties.present?
      render json: properties
    else
      render json: { message: "No properties found within 5 km radius." }, status: :not_found
    end
  end
end
