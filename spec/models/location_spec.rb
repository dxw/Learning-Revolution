require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  before(:each) do
    @valid_attributes = {
      :name => "Location name",
      :postcode => "A1 1AA",
      :address_1 => "Address line 1",
      :address_2 => "Address line 2",
      :address_3 => "Address line 3",
      :city => "City",
      :county => "County",
      :postcode => "postcode"
    }
    @location = Location.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    Location.create!(@valid_attributes).should be_valid
  end
  
  it "should require a name" do
    @location.name = ""
    @location.should_not be_valid
  end
  
  it "should require a postcode" do
    @location.postcode = ""
    @location.should_not be_valid
  end
  
  ["name", "address_1", "address_2", "address_3", "city", "county", "postcode"].each do |field|
    it "should not be valid with a #{field} of more than 255 characters" do
      @location.send("#{field}=", "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
      @location.should_not be_valid
    end
  end
  
end
