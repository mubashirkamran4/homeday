class PropertiesController < ApplicationController
  def nearby
    property = Property.new(property_params)

    if property.valid?
      properties = Property
                    .where(property_type: property.property_type, offer_type: property.offer_type)
                    .where("earth_distance(ll_to_earth(?, ?), ll_to_earth(lat, lng)) <= ?", property.lat, property.lng, 5000)
                    .order(Arel.sql("house_number IS NULL, zip_code IS NULL, street IS NULL, city IS NULL, price ASC")).page(params[:page])
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
    else
      render json: { errors: property.errors.full_messages }
    end
  end

  private
    def property_params
      params.permit(:lat, :lng, :property_type, :marketing_type)
            .transform_keys { |key| key == "marketing_type" ? "offer_type" : key }
    end
end
