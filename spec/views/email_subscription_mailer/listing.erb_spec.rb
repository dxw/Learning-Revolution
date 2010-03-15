require File.dirname(__FILE__) + '/../../spec_helper'

describe "email_subscription_mailer/listing" do
  before(:each) do
    assigns[:email_subscription] = mock_model(EmailSubscription,
      :filter => {:theme => "Food and Cookery", :location => "E11 1PB"},
      :secret => 'abcdefgh',
      :to_param => '1'
    )
    assigns[:events] = [
      mock_model(Event,
        :title => "1001 Things to do with a Lemon",
        :slug => "1001-things-to-do-with-a-lemon",
        :start => Time.utc(2009, 10, 13, 13),
        :end => Time.utc(2009, 10, 13, 14),
        :bitly_url => "http://bit.ly/138746",
        :venue => mock_model(Venue, :name => "Limones Hall", :postcode => "E11 1PB")
      ),
      mock_model(Event,
        :title => "Adventures in Corn",
        :slug => 'adventures-in-corn',
        :start => Time.utc(2009, 10, 15, 19),
        :end => nil,
        :bitly_url => "http://bit.ly/13843546",
        :venue => mock_model(Venue, :name => "The Kernel", :postcode => "E11 1PB")
      )
    ]
  end

  it "should describe the filter" do
    render 'email_subscription_mailer/listing'
    response.body.should =~ /all Food and Cookery events happening within 5 miles of E11 1PB/
  end

  it "should list the events" do
    render 'email_subscription_mailer/listing'
  end

  it "should have a link to subscribe to updates" do
    render 'email_subscription_mailer/listing'
    response.body.should =~ Regexp.new("http://test.host/email_subscriptions/1/confirm/abcdefgh")
  end
end
