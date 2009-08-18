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
      :postcode => "E11 1PB"
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
  
  describe "checking for duplicates" do
    
    it "should not be flagged as a possible duplicate if there's an location with same post code but different name" do
      @location.save!
      similar_attributes = @valid_attributes
      similar_attributes[:name] = "This is a different name"
      new_location = Location.new(similar_attributes)
      new_location.possible_duplicate?.should == false
    end
    
    it "should not be flagged as a possible duplicate if there's an location with same name but different post code" do
      @location.save!
      similar_attributes = @valid_attributes
      similar_attributes[:postcode] = "N4 2LD"
      new_location = Location.new(similar_attributes)
      new_location.possible_duplicate?.should == false
    end
    
    it "should be flagged as a possible duplicate if there is an location with same post code and similar name" do
      @location.save!
      similar_attributes = @valid_attributes
      similar_attributes[:name] = "The Location name"
      new_location = Location.new(similar_attributes)
      new_location.possible_duplicate?.should == true
      new_location.possible_duplicate.should == @location
    end
    
    it "should ignore case" do
      @location.save!
      similar_attributes = @valid_attributes
      similar_attributes[:name] = "LOCATION NAME"
      new_location = Location.new(similar_attributes)
      new_location.possible_duplicate?.should == true
    end
    
    it "should be done on save" do
      @location.should_receive(:possible_duplicate?)
      @location.save!
    end
    
  end
end
