require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailSubscriptionMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  describe "listing" do
    before(:each) do
      @email_subscription = mock_model(EmailSubscription, :email => "example@example.com", :filter => nil)
      @events = [mock_model(Event, :title => nil, :start => Time.now.utc, :end => nil, :venue => nil, :slug => '1')]
      @email = EmailSubscriptionMailer.create_listing(@email_subscription, @events)
    end
  
    it "should be set to be delivered to the correct email address" do
      @email.should deliver_to("example@example.com")
    end
  end
end
