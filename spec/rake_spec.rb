
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

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

  it "should fail when cyberevent is true, but there's an address" do
    lambda { @rake[@task].invoke(RAILS_ROOT+"/spec/rake_data/cyberevent_true_but_has_addr.csv") }.should raise_error(IOError)
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

end
