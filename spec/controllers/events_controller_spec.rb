require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do

  it "should generate an a correct event path" do
    event = EventSpecHelper.new(:title => "Title", :start => Time.parse("1st October 2009"))
    event.stub!(:id).and_return(10)
    controller.path_for_event(event).should == event_path(2009, "October", 1, "title-10") + '?'
  end
  
  it "should be able to generate an ical feed" do
    calendar = mock(:calendar)
    Icalendar::Calendar.should_receive(:new).and_return(calendar)
    calendar.should_receive(:add_event)
    calendar.should_receive(:to_ical)

    event = EventSpecHelper.new()
    event.should_receive(:to_ical_event)
    controller.send(:events_to_ical, [event])
  end
end
