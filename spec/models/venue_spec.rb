require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'ostruct'

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
    @venue = VenueSpecHelper.new(@valid_attributes)

    Upcoming.stub!(:add_venue!)
    Upcoming.stub!(:add_event!)
  end

  it "should create a new instance given valid attributes" do
    Venue.create!(@valid_attributes).should be_valid
  end

  it "should have many events" do
    should have_many(:events)
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

    it "should be able to move all events from another venue" do
      event = EventSpecHelper.new
      @new_dupicate_venue.events << event
      @new_dupicate_venue.save!

      @original_venue.move_events_from(@new_dupicate_venue)
      @original_venue.events.should == [event]
      @new_dupicate_venue.reload
      @new_dupicate_venue.events.should == []
    end

    it "should move all events from the new duplicate event to the original event" do
      @original_venue.should_receive(:move_events_from).with(@new_dupicate_venue)
      @new_dupicate_venue.fix_duplicate(:self)
    end

    it "should move all events from the original duplicate event to the new event" do
      @new_dupicate_venue.should_receive(:move_events_from).with(@original_venue)
      @new_dupicate_venue.fix_duplicate(:original)
    end

  end

  it "should update events with new lat lng on update" do
    venue = VenueSpecHelper.save(:lat => 50.1, :lng => 40)
    event = EventSpecHelper.save(:venue => venue)
    event.lat.should == 50.1
    venue.lat = 100
    venue.lng = 200
    venue.save!
    event.reload
    event.lat.should == 100
    event.lng.should == 200
  end

  it "should find venues by an event filter of theme and type" do
    @event1 = EventSpecHelper.save(:theme => "correct_theme", :event_type => "correct_type")
    @venue1 = @event1.venue
    @event2 = EventSpecHelper.save(:theme => "incorrect_theme", :event_type => "correct_type")
    @venue2 = @event1.venue
    @event3 = EventSpecHelper.save(:theme => "correct_theme", :event_type => "incorrect_type")
    @venue3 = @event1.venue
    Venue.find_venues_by_event_conditions({"events.theme" => "correct_theme", "events.event_type" => "correct_type"}).should == [@venue1]
  end

  it "should find venues by an event filter of theme and type and within a time frame" do
    @event1 = EventSpecHelper.save(:theme => "correct_theme", :start => "2nd October 2009".to_time)
    @venue1 = @event1.venue
    @event2 = EventSpecHelper.save(:theme => "incorrect_theme", :start => "2nd October 2009".to_time)
    @venue1 = @event1.venue
    @event2 = EventSpecHelper.save(:theme => "correct_theme", :start => "9th October 2009".to_time)
    @venue3 = @event1.venue
    Venue.find_venues_by_event_conditions({"events.theme" => "correct_theme", "events.start" => "1st October 2009".to_time.."5th October 2009".to_time}).should == [@venue1]
  end

  it "should generate a active record conditions hash from a form params hash" do
    conditions = Venue.convert_form_params_into_filter_conditions({:theme => "correct_theme", :event_type => "correct_type", :from => "1st October 2009".to_time, :to => "5th October 2009".to_time})
    conditions.should == {"events.theme" => "correct_theme", "events.event_type" => "correct_type", "events.start" => "1st October 2009".to_time.."5th October 2009".to_time}
    Venue.convert_form_params_into_filter_conditions({}).should == {}
  end

  it "generating an active record conditions hash from a form params hash should not choke on nil values" do
    Venue.convert_form_params_into_filter_conditions({}).should == {}
  end

  it "should find venues from a form params in one fell swoop" do
    filter = {}
    Venue.should_receive(:convert_form_params_into_filter_conditions).with(filter).and_return(ret={})
    Venue.should_receive(:find_venues_by_event_conditions).with(ret)
    Venue.find_venues_by_event_params(filter)
  end

  it "should find events of a venue by the form params" do
    filter = {}
    Venue.should_receive(:convert_form_params_into_filter_conditions).with(filter).and_return(ret={})
    @venue.events.should_receive(:find).with(:all, :conditions => ret)
    @venue.find_events_by_event_params(filter)
  end

  describe "posting to Upcoming" do
    it "should not post to Upcoming again if it already has an Upcoming venue ID" do
      @venue.upcoming_venue_id = 12345
      @venue.save!

      Upcoming.should_not_receive(:add_venue!)
      @venue.generate_upcoming_venue_id!.should == 12345
    end

    it "should post to Upcoming if it has not already been posted" do
      Upcoming.should_receive(:add_venue!).with(
        :venuename => 'Venue name',
        :venueaddress => 'Address line 1',
        :venuecity => 'City',
        :location => 'Address line 1,Address line 2,Address line 3,City,County,E11 1PB,UK',
        :venuezip => 'E11 1PB'
      ).and_return(OpenStruct.new(:venue_id => 98765))

      @venue.save!
      @venue.generate_upcoming_venue_id!.should == 98765
      @venue.reload
      @venue.upcoming_venue_id.should == 98765
    end
  end
end
