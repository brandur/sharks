class Incident < ActiveRecord::Base
  acts_as_mappable
  attr_protected :lat, :lng, :full_address
  before_save :geocode
  default_scope :order => 'occurred_on DESC'
  validates_presence_of :case_id
  validates_uniqueness_of :case_id

  def location_raw
    location_parts = []
    location_parts << location if location
    location_parts << area     if area
    location_parts << country  if country
    location_parts.join(', ')
  end

  def location_str
    if full_address
      full_address
    else
      location_raw
    end
  end

  private

  # @todo: delayed job?
  def geocode
    # Only re-geocode if one of the location fields has changed
    return unless location_changed? || area_changed? || country_changed?

    loc = Geokit::Geocoders::MultiGeocoder.geocode(location_raw)
    logger.info "Geocode for '#{case_id}' is #{loc.success ? loc.ll + '/' + loc.full_address : 'nil'}"
    self.lat, self.lng, self.full_address = loc.lat, loc.lng, loc.full_address if loc.success
  end
end
