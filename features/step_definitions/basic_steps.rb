require 'markup_validity' 

Given "debugger" do
  debugger
end

Then /^there should be (\d+) (\S+) in the database$/ do |count, model|
  eval("#{model}.count").should == count.to_i
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