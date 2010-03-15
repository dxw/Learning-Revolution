module VenueSpecHelper

  def self.new(options={})
    do_geocode = options[:geocode_address]
    options.delete :geocode_address
    v = Venue.new(
      {
        :name => "Venue name",
        :postcode => "A1 1AA",
        :address_1 => "Address line 1",
        :address_2 => "Address line 2",
        :address_3 => "Address line 3",
        :city => "City",
        :county => "County",
        :postcode => "E11 1PB"
      }.merge(options)
    )
    v.stub!(:geocode_address) unless do_geocode
    v
  end

  def self.save(options={})
    r = self.new(options)
    r.save!
    r
  end

  def self.mock_geo(lat=5, lng=5)
    geoloc = Geokit::GeoLoc.new
    geoloc.stub!(:lat).and_return(lat)
    geoloc.stub!(:lng).and_return(lng)
    geoloc.stub!(:success).and_return(true)
    Geokit::Geocoders::YahooGeocoder.stub!(:geocode).and_return(geoloc)
  end
end
