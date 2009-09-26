require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailSubscription do
  it "should serialize the filter attribute" do
    es = EmailSubscription.create(:filter => {'location' => 'NR28 9JH', 'theme' => 'Food and Cookery'}, :email => "example@example.com")
    es.reload
    es.filter.should == {'location' => 'NR28 9JH', 'theme' => 'Food and Cookery'}
  end
  
  it "should send the initial listing email after being created" do
    es = EmailSubscription.new(:email => "example@example.com")
    EmailSubscriptionMailer.should_receive(:deliver_listing).with(es)
    es.save
  end
end
