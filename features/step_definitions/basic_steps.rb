require 'markup_validity' 

Given "debugger" do
  debugger
end

Then /^there should be (\d+) (\S+) in the database$/ do |count, model|
  eval("#{model}.count").should == count.to_i
end

Then /^there should be an? (\S+) whose (\S+) is "(.*?)"$/ do |model, field, value|
  eval(model).find(:all, :conditions => {field.to_sym => value}).count.should > 0
end

Then /^there should be an? (\S+) whose (\S+) datetime is "(.*?)"$/ do |model, field, dt|
  value = Time.zone.parse(dt)
  eval(model).find(:all, :conditions => {field.to_sym => value}).count.should > 0
end

Given /^I am logged in$/ do
  basic_auth('lr_admin', 'learning is fun!')
end

Then /^I should be denied access$/ do
  response.code.should == "401"
end

Then %r/the page is valid XHTML/ do
  response.body.should(be_xhtml_strict) unless ENV['SKIP_VALIDATION']
end

Then /^I should see image "([^\"]*)"$/ do |alt|
  response.should have_selector("img", :alt => alt)
end

Then /^I should not see image "([^\"]*)"$/ do |alt|
  response.should_not have_selector("img", :alt => alt)
end

