require File.dirname(__FILE__) + '/../../spec_helper'

describe "email_subscription_mailer/listing" do
  before(:each) do
    assigns[:email_subscription] = mock_model(EmailSubscription,
      :filter => {:theme => "Food and Cookery", :location => "E11 1PB"}
    )
    assigns[:events] = [
      mock_model(Event,
        :title => "1001 Things to do with a Lemon",
        :slug => "1001-things-to-do-with-a-lemon",
        :start => Time.utc(2009, 10, 13, 13),
        :end => Time.utc(2009, 10, 13, 14),
        :venue => mock_model(Venue, :name => "Limones Hall")
      ),
      mock_model(Event,
        :title => "Adventures in Corn",
        :slug => 'adventures-in-corn',
        :start => Time.utc(2009, 10, 15, 19),
        :end => nil,
        :venue => mock_model(Venue, :name => "The Kernel")
      )
    ]
  end
  
  it "should describe the filter" do
    render 'email_subscription_mailer/listing'
    response.body.should =~ /all Food and Cookery events happening within 5 miles of E11 1PB/
  end
  
  it "should list the events" do
    render 'email_subscription_mailer/listing'
    
    response.body.should =~ /1001 Things to do with a Lemon/
    response.body.should =~ /13 October 13:00PM until 14:00PM/
    response.body.should =~ /Limones Hall/
    response.body.should =~ /http:\/\/test.host\/events\/2009\/10\/13\/1001-things-to-do-with-a-lemon/
    
    response.body.should =~ /Adventures in Corn/
    response.body.should =~ /15 October 19:00PM/
    response.body.should =~ /The Kernel/
    response.body.should =~ /http:\/\/test.host\/events\/2009\/10\/15\/adventures-in-corn/
  end
end
