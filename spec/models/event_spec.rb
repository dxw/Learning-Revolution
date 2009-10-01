require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @event = EventSpecHelper.new
    
    Upcoming.stub!(:add_venue!)
    Upcoming.stub!(:add_event!)
  end

  it "should create a new instance given valid attributes" do
    EventSpecHelper.save.should be_valid
  end
  
  it "should belong to a venue" do
    @event.should belong_to(:venue)
  end
  
  it "should not be valid without a title" do
    @event.title = ""
    @event.should_not be_valid
  end
  
  it "should not be valid without a theme" do
    @event.theme = ""
    @event.should_not be_valid
  end
  
  it "should not be valid without a event type" do
    @event.event_type = ""
    @event.should_not be_valid
  end
    
  it "should not be valid without a contact name" do
    @event.contact_name = ""
    @event.should_not be_valid
  end
  
  it "should not be valid without a contact email address and contact phone number" do
    @event.contact_email_address = ""
    @event.contact_phone_number = ""
    @event.should_not be_valid
  end
  
  it "should not be valid without a contact email address but with a contact phone number" do
    @event.contact_email_address = ""
    @event.contact_phone_number = "079384759234"
    @event.should_not be_valid
  end
  
  it "should be valid without a contact phone number but with a contact email address" do
    @event.contact_email_address = "james@abscond.org"
    @event.contact_phone_number = ""
    @event.should be_valid
  end
    
  it "not be valid without a start time" do
    @event.start = nil
    @event.should_not be_valid
  end
  
  it "should accept approval" do
    @event.should_receive(:save)
    @event.approve!
    @event.published.should == true
  end
  
  it "should find featured events" do
    @event.save!
    Event.featured.should == []
    @event.featured = true
    @event.published = true
    @event.save!
    Event.featured.should == [@event]
  end
  
  describe "more_info validation" do    
    it "should add http:// to the beginning of links if it's missing" do
      @event.more_info = "www.google.com"
      @event.save!
      @event.more_info.should == "http://www.google.com"
    end
    
    it "should not add http:// to the beginning of links if it's already there" do
      @event.more_info = "http://www.google.com"
      @event.save!
      @event.more_info.should == "http://www.google.com"
    end
    
    it "should not add http:// to the beginning of blank links" do
      @event.more_info = ""
      @event.save!
      @event.more_info.should == ""
    end
    
    it "should always return true" do
      @event.check_more_info.should == true
    end
  end
  
  describe "checking for duplicates" do
    
    it "should not be flagged as a possible duplicate if there's an event with same date but different title" do
      @event.save!
      EventSpecHelper.new(:title => "This is a different title").possible_duplicate?.should == false
    end
    
    it "should not be flagged as a possible duplicate if there's an event with same title but different date" do
      @event.save!
      EventSpecHelper.new(:start => Date.today+2.days).possible_duplicate?.should == false
    end
    
    it "should be flagged as a possible duplicate if there is an event with same date and similar title" do
      @event.save!
      new_event = EventSpecHelper.new(:title => "value for title2")
      new_event.possible_duplicate?.should == true
      new_event.possible_duplicate.should == @event
    end
    
    it "should ignore case" do
      @event.save!
      EventSpecHelper.new(:title => "VALUE FOR TITLE").possible_duplicate?.should == true
    end
    
    it "should be done on save" do
      @event.should_receive(:possible_duplicate?)
      @event.save!
    end
    
    it "should not use itself as a duplicate" do
      @event.save!
      @event.save!
      @event.possible_duplicate.should == nil
    end
    
  end
  
  describe "fixing duplicates" do
    before(:each) do
      @original_event = @event
      @new_dupicate_event = EventSpecHelper.new
      @new_dupicate_event.possible_duplicate = @original_event
    end
    
    it "should be able to succesfully delete the original duplicate" do
      @original_event.should_receive(:destroy)
      @new_dupicate_event.fix_duplicate(:original)
    end
    
    it "should be remove reference to original duplicate upon fixing" do
      @new_dupicate_event.fix_duplicate(:original)
      @new_dupicate_event.possible_duplicate.should == nil
    end
    
    it "should delete itself if it is told it is the duplicate" do
      @new_dupicate_event.should_receive(:destroy)
      @new_dupicate_event.fix_duplicate(:self)
    end  
  end
  
  describe "making bitly URLs" do
    before(:each) do      
      @client = mock(:client)
      Bitly.stub!(:new).and_return(@client)
      @mock_response = mock(:bitly)
      @mock_response.stub!(:short_url).and_return(@test_string = "oogieboogieboo")
    end
    
    it "should call Bitly to create a short uri for an event" do
      event = Event.new(EventSpecHelper.valid_attributes)
      @client.should_receive(:shorten).with(/http:\/\/localhost\/events\/\d+\/\d+\/\d+\/value-for-title-\d+/).and_return(@mock_response)
      event.save
    end
    
    it "should set the event's bitly url" do
      
      @client.stub!(:shorten).and_return(@mock_response)
      
      event = Event.create(EventSpecHelper.valid_attributes)
      
      event.bitly_url.should == @test_string
    end
    
  end
  
  describe "filtering events" do
    before(:each) do
    end
    
    it "should generate the sql for finding events on a day" do
      Event.sql_for_events_on_day_with_filter(Time.parse("1st October 2009")).should == "SELECT * FROM `events` WHERE ((start >= '2009-09-30 23:00:00' AND start < '2009-10-01 22:59:59')) "
    end
    
    it "should generate the sql for finding events in a month" do
      Event.sql_for_events_in_month_with_filter(Time.parse("1st October 2009")).should include("(SELECT * FROM `events` WHERE ((start >= '2009-09-30 23:00:00' AND start < '2009-10-01 22:59:59')) ) UNION (SELECT * FROM `events` WHERE ((start >= '2009-10-01 23:00:00' AND start < '2009-10-02 22:59:59')) ) UNION (SELECT * FROM `events` WHERE ((start >= '2009-10-02 23:00:00' AND start < '2009-10-03 22:59:59')) ) ")
    end
    
    it "should generate the sql for finding events in a month with a filter" do
      Event.sql_for_events_in_month_with_filter(Time.parse("1st October 2009"), :conditions => ["TEST", "TEST"]).should include("SELECT * FROM `events` WHERE (TEST AND (start >= '2009-09-30 23:00:00' AND start < '2009-10-01 22:59:59')) ) UNION (SELECT * FROM `events` WHERE (TEST AND (start >= '2009-10-01 23:00:00' AND start < '2009-10-02 22:59:59')) )")
    end
    
    it "should generate find conditions from form params" do
      find_options = Event.turn_filter_params_into_find_options(:theme => "theme_name", :event_type => "type_name", :location => "E11 1PB")
      find_options.should == {:within => 5, :limit => 4, :conditions => ["(theme LIKE ? AND event_type LIKE ?) AND (published = 1)", "%theme_name%", "%type_name%"], :origin => "E11 1PB GB"}
      find_options = Event.turn_filter_params_into_find_options(:theme => "theme_name")
      find_options.should == {:limit => 4, :conditions => ["(theme LIKE ?) AND (published = 1)", "%theme_name%"]}
      find_options = Event.turn_filter_params_into_find_options(:event_type => "type_name")
      find_options.should == {:limit => 4, :conditions => ["(event_type LIKE ?) AND (published = 1)", "%type_name%"]}
    end
    
    it "should auto convert params into find options on find by month" do
      params = {}
      date = Date.today
      Event.should_receive(:turn_filter_params_into_find_options).with(params).and_return(ret={})
      Event.should_receive(:find_by_month_with_filter).with(date, ret)
      Event.find_by_month_with_filter_from_params(date, params)
    end
    
    
    it "should find events in a month" do
      event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"))
      event2 = EventSpecHelper.save(:start => Time.parse("31st October 2009 11:59"))
      event3 = EventSpecHelper.save(:start => Time.parse("1st November 2009"))
      Event.find_by_month_with_filter(Time.parse("1st October 2009")).should == [event1, event2]
    end
    
    it "should be able to filter events in a month by theme" do
      event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"), :theme => "cooking", :event_type => "class")
      event2 = EventSpecHelper.save(:start => Time.parse("1st October 2009"), :theme => "swimming", :event_type => "test")
      event3 = EventSpecHelper.save(:start => Time.parse("1st November 2009"), :theme => "cooking", :event_type => "class")
      event4 = EventSpecHelper.save(:start => Time.parse("1st November 2009"), :theme => "swimming", :event_type => "test")
      Event.find_by_month_with_filter(Time.parse("1st October 2009"), :conditions => ["theme LIKE ?", "%cooking%"]).should == [event1]
    end
    
    it "should be able to filter events in a month by event_type" do
      event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"), :theme => "cooking", :event_type => "class")
      event2 = EventSpecHelper.save(:start => Time.parse("1st October 2009"), :theme => "swimming", :event_type => "test")
      event3 = EventSpecHelper.save(:start => Time.parse("1st November 2009"), :theme => "cooking", :event_type => "class")
      event4 = EventSpecHelper.save(:start => Time.parse("1st November 2009"), :theme => "swimming", :event_type => "test")
      Event.find_by_month_with_filter(Time.parse("1st October 2009"), :conditions => ["event_type LIKE ?", "%class%"]).should == [event1]
    end
    
    it "should be able to filter events in a month by theme and event_type" do
      event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"), :theme => "cooking", :event_type => "class")
      event2 = EventSpecHelper.save(:start => Time.parse("1st October 2009"), :theme => "swimming", :event_type => "test")
      event3 = EventSpecHelper.save(:start => Time.parse("1st November 2009"), :theme => "cooking", :event_type => "class")
      event4 = EventSpecHelper.save(:start => Time.parse("1st November 2009"), :theme => "swimming", :event_type => "test")
      Event.find_by_month_with_filter(Time.parse("1st October 2009"), :conditions => ["theme LIKE ? AND event_type LIKE ?", "%cooking%", "%class%"]).should == [event1]
    end
      
  end
    
  it "should find events on same day" do
    event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"))
    event2 = EventSpecHelper.save(:start => Time.parse("2nd October 2009"))
    event3 = EventSpecHelper.save(:start => Time.parse("1st October 2009"))
    event1.same_day_events.to_set.should == Set.new([event1, event3])
  end
  
  it "should cache lat lng from it's location on create" do
    v = VenueSpecHelper.new(:lat => 50.0001, :lng => -50.0001)
    e = EventSpecHelper.new(:venue => v)
    e.save
    e.lat.should == 50.0001
    e.lng.should == -50.0001
  end
  
  it "should be able to find the first event of a day" do
    past_event = EventSpecHelper.save(:start => Time.parse("1st October 2009 10:00"))
    present_event = EventSpecHelper.save(:start => Time.parse("2nd October 2009 10:00"))
    future_event = EventSpecHelper.save(:start => Time.parse("3rd October 2009 10:00"))
    Event.first_for_day(Time.parse("2nd October 2009 10:00")).should == present_event
  end
  
  it "should find the next event by day" do
    event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"))
    event2 = EventSpecHelper.save(:start => Time.parse("2nd October 2009"))
    event3 = EventSpecHelper.save(:start => Time.parse("3nd October 2009"))
    Event.step_forwards_from(event1).should==event2
  end
  
  it "should find the next event by day when there is an intervening day with no events" do
    event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"))
    event3 = EventSpecHelper.save(:start => Time.parse("3nd October 2009"))
    
    Event.step_forwards_from(event1).should==event3
  end
  
  it "should find the previous event by day" do
    event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"))
    event2 = EventSpecHelper.save(:start => Time.parse("2nd October 2009"))
    event3 = EventSpecHelper.save(:start => Time.parse("3nd October 2009"))
    Event.step_backwards_from(event2).should==event1
  end
  
  it "should find the previous event by day when there is an intervening day with no events" do
    event1 = EventSpecHelper.save(:start => Time.parse("1st October 2009"))
    event3 = EventSpecHelper.save(:start => Time.parse("3nd October 2009"))
    
    Event.step_backwards_from(event3).should==event1
  end
  
  it "should generate a slug of the-events-title-id from 'The Event's Title'" do
    @event.title = "The Event's Title"
    @event.stub!(:id).and_return(23)
    @event.slug.should == "the-events-title-23"
  end
  
  it "should be able to find by slug" do
    @event.title = "The Event's Title"
    @event.stub!(:id).and_return(23)
    Event.should_receive(:find_by_id).with("23")
    Event.find_by_slug("the-events-title-23")
  end

  it "should be happy outputting ical" do
    @event.to_ical.should be_a(String)
  end

  it "should be happy outputting ical with no description" do
    @event.description = nil
    @event.to_ical.should be_a(String)
  end

  it "should not be valid without a start" do
    @event.start = nil
    @event.should_not be_valid
  end

  it "should not allow invalid email addresses" do
    @event.contact_email_address = 'tom at thedextrousweb.com'
    @event.should_not be_valid
  end

  it "should be happy with BST" do
    a = EventSpecHelper.save(:start => Time.parse("1st October 2009 00:00"))
    b = EventSpecHelper.save(:start => Time.parse("1st October 2009 12:00"))
    a.same_day_events.should include(b)
  end

  it "should be happy with BST in first_for_day" do
    a = EventSpecHelper.save(:start => Time.parse("5th October 2009 00:00"))
    b = EventSpecHelper.save(:start => Time.parse("5th October 2009 12:00"))
    Event.first_for_day(Time.zone.local(2009,10,5).to_date).should == a
  end
end
