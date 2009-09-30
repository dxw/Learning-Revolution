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
  def err(s)
    puts "    \33[30;46m#{s}\33[0m"
  end
  if ENV['SKIP_VALIDATION']
    err "You have SKIP_VALIDATION set."
    err "Unset it to test XHTML validity."
    err "You should do this."
  else
    response.body.should(be_xhtml_strict)
  end
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

Then "what" do
  puts response.body
end

Then "where" do
  puts "#{@request.env["SERVER_NAME"]}#{@request.env["REQUEST_URI"]}" 
end
