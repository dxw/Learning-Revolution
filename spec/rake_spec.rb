require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rake'

describe "rake lr:import" do
  before do
    @task = "lr:import"
  end

  def bef
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake::Task.define_task(:environment)
    load RAILS_ROOT+"/lib/tasks/lr.rake"
  end

  def aft
    Rake.application = nil
  end

  before(:each) do
    bef
  end

  after(:each) do
    aft
  end

  it "should fail with no arguments" do
    lambda { @rake[@task].invoke }.should raise_error
  end

  it "should succeed with a valid CSV file" do
    @rake[@task].invoke(RAILS_ROOT+"/spec/rake_data/valid.csv")
    Event.last.start.should == Time.zone.local(2009,10,15,12,30)
    Event.last.cost.should == "\xc2\xa34"
  end

  it "should fail with a non-CSV file" do
    lambda { @rake[@task].invoke(RAILS_ROOT+"/lib/tasks/lr.rake") }.should raise_error(IOError)
  end

  it "should fail when cyberevent is false, but there's no address" do
    lambda { @rake[@task].invoke(RAILS_ROOT+"/spec/rake_data/cyberevent_false_but_no_addr.csv") }.should raise_error(IOError)
  end

  it "should fail without a * field" do
    Dir.glob(RAILS_ROOT+"/spec/rake_data/no_*.csv").each {|csv|
      bef
      lambda { @rake[@task].invoke(csv) }.should raise_error(IOError)
      aft
    }
  end
  
  it "should fail when an event is not in october" do
    lambda { @rake[@task].invoke(RAILS_ROOT+"/spec/rake_data/event_not_in_october_2009.csv") }.should raise_error(IOError)
  end
  
  it "should fail when an event ends before it starts" do
    lambda { @rake[@task].invoke(RAILS_ROOT+"/spec/rake_data/event_ends_before_starts.csv") }.should raise_error(IOError)
  end

  it "should be happy with real_data" do
    #@rake['lr:dev:real_data'].invoke
  end

end

describe "rake lr:move_to_theme" do
  before do
    @task = "lr:move_to_theme"
  end

  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake::Task.define_task(:environment)
    load RAILS_ROOT+"/lib/tasks/lr.rake"
    ENV['Q'] = nil
    ENV['T'] = nil
  end

  it "should break without Q or T" do
    lambda { @rake[@task].invoke }.should raise_error
  end

  it "should break without Q" do
    ENV['T'] = 'helo'
    lambda { @rake[@task].invoke }.should raise_error
  end

  it "should break without T" do
    ENV['Q'] = 'helo'
    lambda { @rake[@task].invoke }.should raise_error
  end
end
