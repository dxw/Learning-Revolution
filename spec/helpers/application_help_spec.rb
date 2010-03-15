require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do

  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ApplicationHelper)
  end

  #it "should return a properly formatted postcode" do
    # AN NAA    M1 1AA
    # ANN NAA   M60 1NW
    # AAN NAA   CR2 6XH
    # AANN NAA  DN55 1PT
    # ANA NAA   W1A 1HQ
    # AANA NAA  EC1A 1BB
  #end

  describe "url_for_event" do
    before(:each) do
      @event = mock_model(Event, :start => Time.utc(2009, 10, 13), :slug => "beginners-ressikan-flute")
    end

    it "should return a full event URL" do
      helper.url_for_event(@event).should == 'http://test.host/events/2009/10/13/beginners-ressikan-flute'
    end

    it "should pass options on to the built-in URL helpers" do
      helper.url_for_event(@event, :only_path => true).should == '/events/2009/10/13/beginners-ressikan-flute'
    end
  end
end
