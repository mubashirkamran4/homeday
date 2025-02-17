class Property < ApplicationRecord
  VALID_PROPERTY_TYPES = [ "apartment", "single_family_house" ].freeze
  VALID_MARKETING_TYPES = [ "rent", "sell" ].freeze
  attr_accessor :marketing_type
  before_validation :map_marketing_type

  validates :property_type, inclusion: { in: VALID_PROPERTY_TYPES, message: "invalid. Must be either 'apartment' or 'single_family_house'." }
  validates :offer_type, inclusion: { in: VALID_MARKETING_TYPES, message: "invalid. Must be either 'rent' or 'sell'." }

  validate :coordinates_within_germany

  validates :lat, presence: { message: "is required" }

  validates :lng, presence: { message: "is required" }

  private

  def map_marketing_type
    self.offer_type = marketing_type if marketing_type.present?
  end

  def coordinates_within_germany
    return if lat.blank? || lng.blank?

    errors.add(:base, "Coordinates must be within Germany's borders.") unless lat.between?(47.2701, 55.0584) && lng.between?(5.8663, 15.0419)
  end
end
