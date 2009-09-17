
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

describe "rake lr:import" do
  before do
    @task = "lr:import"
  end

  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake::Task.define_task(:environment)
    load RAILS_ROOT+"/lib/tasks/lr.rake"
  end

  after(:each) do
    Rake.application = nil
  end

  it "should fail with no arguments" do
    lambda { @rake[@task].invoke }.should raise_error
  end

  it "should succeed with a valid CSV file" do
    @rake[@task].invoke(RAILS_ROOT+"/spec/rake_data/valid.csv")
  end

  it "should fail with a non-CSV file" do
    lambda { @rake[@task].invoke(RAILS_ROOT+"/lib/tasks/lr.rake") }.should raise_error(IOError)
  end

end
