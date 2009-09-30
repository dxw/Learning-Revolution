require 'markup_validity' 

module Spec
  module Matchers
    def be_atom
      Matcher.new :be_atom do
        match do |atom|
          rng = Nokogiri::XML::RelaxNG(open('features/step_definitions/atom.rng').read)
          feed = Nokogiri::XML(atom)
          rng.valid?(feed)
        end

        failure_message_for_should do |actual|
          atom
        end
      end
    end
    def be_icalendar
      Matcher.new :be_icalendar do
        match do |ical|
          calendar = Icalendar.parse(ical)
        end

        failure_message_for_should do |actual|
          calendar
        end
      end
    end
  end
end

Given "debugger" do
  debugger
end

Then /^there should be (\d+) (\S+) in the database$/ do |count, model|
  eval("#{model}.count").should == count.to_i
end

Then /^there should be an? (\S+) whose (\S+) is "(.*?)"$/ do |model, field, value|
  eval(model).find(:all, :conditions => {field.to_sym => value}).size.should > 0
end

Then /^there should be an? (\S+) whose (\S+) datetime is "(.*?)"$/ do |model, field, dt|
  value = Time.zone.parse(dt)
  eval(model).find(:all, :conditions => {field.to_sym => value}).size.should > 0
end

Given /^I am logged in$/ do
  basic_auth('lr_admin', 'learning is fun!')
end

Then /^I should be denied access$/ do
  response.code.should == "401"
end

Then %r/the page is valid XHTML/ do
  pending and return if ENV['SKIP_VALIDATION']
  response.body.should(be_xhtml_strict)
end

Then %r/the page is valid Atom/ do
  response.body.should(be_atom)
end

Then %r/the page is valid iCalendar/ do
  response.body.should(be_icalendar)
end
Then %r/the calendar holds (\d+) events?/ do |count|
  calendar = Icalendar.parse(response.body)[0] # files can contain multiple calendars, therefore this index
  calendar.events.size.should == count.to_i
end

Then /^I should see image "([^\"]*)"$/ do |alt|
  response.should have_selector("img", :alt => alt)
end

Then /^I should not see image "([^\"]*)"$/ do |alt|
  response.should_not have_selector("img", :alt => alt)
end

