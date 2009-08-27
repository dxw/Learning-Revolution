def find_or_build(object, attrs = {})
  result = object.send(:find, :first, {:conditions => attrs})
  unless result.blank?
    result
  else
    object.send(:new, attrs)
  end  
end

def find_or_create(object, attrs={})
  result = object.send(:find, :first, {:conditions => attrs})
  unless result.blank?
    result
  else
    object.send(:create!, attrs)
  end
end

geoloc = Geokit::GeoLoc.new
geoloc.stub!(:lat).and_return(0.0088174)
geoloc.stub!(:lng).and_return(51.5754841)
geoloc.stub!(:success).and_return(true)
Geokit::Geocoders::YahooGeocoder.stub!(:geocode).and_return(geoloc)
Geokit::Geocoders::GoogleGeocoder.stub!(:geocode).and_return(geoloc)
