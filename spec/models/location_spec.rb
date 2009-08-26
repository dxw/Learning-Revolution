require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  it "should geolocate from postcode on create" do
    geoloc = Geokit::GeoLoc.new
    geoloc.stub!(:lat).and_return(50.0001)
    geoloc.stub!(:lng).and_return(-50.0001)
    geoloc.stub!(:success).and_return(true)
    Geokit::Geocoders::YahooGeocoder.should_receive(:geocode).and_return(geoloc)
    location = VenueSpecHelper.save(:geocode_address => true)
    location.lat.should == 50.0001
    location.lng.should == -50.0001
  end
end
