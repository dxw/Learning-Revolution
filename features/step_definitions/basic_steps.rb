Given "debugger" do
  debugger
end

Then /^there should be (\d+) (\S+) in the database$/ do |count, model|
  eval("#{model}.count").should == count.to_i
end
