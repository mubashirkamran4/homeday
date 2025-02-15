class PropertiesController < ApplicationController
  def nearby
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    property_type = params[:property_type]
    marketing_type = params[:marketing_type]

    errors = []
    errors << "All parameters must be provided" if lat.zero? || lng.zero? || property_type.blank? || marketing_type.blank?
    errors << "Invalid Property Type" if !property_type.in?(Property.select(:property_type).distinct.map(&:property_type))
    errors << "Invalid Marketing Type" if !marketing_type.in?(Property.select(:offer_type).distinct.map(&:offer_type))

    return render json: { errors: errors } unless errors.empty?
    properties = Property
                  .where(property_type: params[:property_type], offer_type: params[:marketing_type])
                  .where("earth_distance(ll_to_earth(?, ?), ll_to_earth(lat, lng)) <= ?", params[:lat], params[:lng], 5000).page(params[:page])

    if properties.present?
      render json: {
        properties: properties,
        meta: {
          current_page: properties.current_page,
          total_pages: properties.total_pages,
          total_count: properties.total_count
        }
      }
    else
      render json: { message: "No properties found within 5 km radius." }
    end
  end
end
