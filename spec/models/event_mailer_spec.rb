require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  describe "succesfully added email" do
    before(:each) do
      @event = mock_model(Event, :title => "Test event name", :contact_email_address => "test@abscond.org", :start => Time.now.utc, :end => nil, :venue => nil, :slug => '1', :bitly_url => "http://bit.ly/skdjfg")
      @email = EventMailer.create_succesfully_added(@event)
    end
  
    it "should be set to be delivered to the correct email address" do
      @email.should deliver_to("test@abscond.org")
    end
    
    it "should contain the event name" do
      @email.body.should include("Test event name")
    end
  end
  
  describe "succesfully posted email" do
    before(:each) do
      @event = mock_model(Event, :title => "Test event name", :contact_email_address => "test@abscond.org", :start => Time.now.utc, :end => nil, :venue => nil, :slug => '1', :bitly_url => "http://bit.ly/skdjfg")
      @email = EventMailer.create_succesfully_published(@event)
    end
  
    it "should be set to be delivered to the correct email address" do
      @email.should deliver_to("test@abscond.org")
    end
    
    it "should contain the event name" do
      @email.body.should include("Test event name")
    end
    
    it "should include the bitly event URL" do
      @email.body.should include("http://bit.ly/skdjfg")
    end
  end
  
end
