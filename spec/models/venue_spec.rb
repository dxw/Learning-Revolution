require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Venue do
  before(:each) do
    @valid_attributes = {
      :name => "Venue name",
      :postcode => "A1 1AA",
      :address_1 => "Address line 1",
      :address_2 => "Address line 2",
      :address_3 => "Address line 3",
      :city => "City",
      :county => "County",
      :postcode => "E11 1PB"
    }
    @venue = Venue.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    Venue.create!(@valid_attributes).should be_valid
  end
  
  it "should require a name" do
    @venue.name = ""
    @venue.should_not be_valid
  end
  
  it "should require a postcode" do
    @venue.postcode = ""
    @venue.should_not be_valid
  end
  
  ["name", "address_1", "address_2", "address_3", "city", "county", "postcode"].each do |field|
    it "should not be valid with a #{field} of more than 255 characters" do
      @venue.send("#{field}=", "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
      @venue.should_not be_valid
    end
  end
  
  describe "checking for duplicates" do
    
    it "should not be flagged as a possible duplicate if there's an venue with same post code but different name" do
      @venue.save!
      similar_attributes = @valid_attributes
      similar_attributes[:name] = "This is a different name"
      new_venue = Venue.new(similar_attributes)
      new_venue.possible_duplicate?.should == false
    end
    
    it "should not be flagged as a possible duplicate if there's an venue with same name but different post code" do
      @venue.save!
      similar_attributes = @valid_attributes
      similar_attributes[:postcode] = "N4 2LD"
      new_venue = Venue.new(similar_attributes)
      new_venue.possible_duplicate?.should == false
    end
    
    it "should be flagged as a possible duplicate if there is an venue with same post code and similar name" do
      @venue.save!
      similar_attributes = @valid_attributes
      similar_attributes[:name] = "The Venue name"
      new_venue = Venue.new(similar_attributes)
      new_venue.possible_duplicate?.should == true
      new_venue.possible_duplicate.should == @venue
    end
    
    it "should ignore case" do
      @venue.save!
      similar_attributes = @valid_attributes
      similar_attributes[:name] = "VENUE NAME"
      new_venue = Venue.new(similar_attributes)
      new_venue.possible_duplicate?.should == true
    end
    
    it "should be done on save" do
      @venue.should_receive(:possible_duplicate?)
      @venue.save!
    end
    
    it "should not use itself as a duplicate" do
      @venue.save!
      @venue.save!
      @venue.possible_duplicate.should == nil
    end
    
  end
  
  describe "fixing duplicates" do
    before(:each) do
      @original_venue = @venue
      @new_dupicate_venue = Venue.new(@valid_attributes)
      @new_dupicate_venue.possible_duplicate = @original_venue
    end
    
    it "should be able to succesfully delete the original duplicate" do
      @original_venue.should_receive(:destroy)
      @new_dupicate_venue.fix_duplicate(:original)
    end
    
    it "should be remove reference to original duplicate upon fixing" do
      @new_dupicate_venue.fix_duplicate(:original)
      @new_dupicate_venue.possible_duplicate.should == nil
    end
    
    it "should delete itself if it is told it is the duplicate" do
      @new_dupicate_venue.should_receive(:destroy)
      @new_dupicate_venue.fix_duplicate(:self)
    end
    
  end
  
end
