require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :theme => "value for theme",
      :type => "value for type",
      :stage => 1,
      :start => Time.now,
      :end => Time.now,
      :cost => "value for cost",
      :min_age => 1,
      :organisation => "value for organisation",
      :contact_name => "value for contact_name",
      :contact_phone_number => "value for contact_phone_number",
      :contact_email_address => "value for contact_email_address",
      :further_information => "value for further_information",
      :additional_notes => "value for additional_notes",
      :published => false,
      :picture => "value for picture",
      :featured => false
    }
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes).should be_valid
  end
end
