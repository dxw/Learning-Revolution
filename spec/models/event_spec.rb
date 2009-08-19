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
    @event = Event.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes).should be_valid
  end
  
  it "not be valid without a title" do
    @event.title = ""
    @event.should_not be_valid
  end
  
  it "not be valid without a start time" do
    @event.start = nil
    @event.should_not be_valid
  end
  
  describe "checking for duplicates" do
    
    it "should not be flagged as a possible duplicate if there's an event with same date but different title" do
      @event.save!
      similar_attributes = @valid_attributes
      similar_attributes[:title] = "This is a different title"
      new_event = Event.new(similar_attributes)
      new_event.possible_duplicate?.should == false
    end
    
    it "should not be flagged as a possible duplicate if there's an event with same title but different date" do
      @event.save!
      similar_attributes = @valid_attributes
      similar_attributes[:start] = Date.today+2.days
      new_event = Event.new(similar_attributes)
      new_event.possible_duplicate?.should == false
    end
    
    it "should be flagged as a possible duplicate if there is an event with same date and similar title" do
      @event.save!
      similar_attributes = @valid_attributes
      similar_attributes[:title] = "the value for title"
      new_event = Event.new(similar_attributes)
      new_event.possible_duplicate?.should == true
      new_event.possible_duplicate.should == @event
    end
    
    it "should ignore case" do
      @event.save!
      similar_attributes = @valid_attributes
      similar_attributes[:title] = "VALUE FOR TITLE"
      new_event = Event.new(similar_attributes)
      new_event.possible_duplicate?.should == true
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
      @new_dupicate_event = Event.new(@valid_attributes)
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
end
