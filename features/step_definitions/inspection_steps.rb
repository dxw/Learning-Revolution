Then /^I should see "([^\"]*)" in the (.*)$/ do |text, section_name|
  response.should have_xpath(xpath_of_section(section_name)) do |section|
    section.should contain(text)
  end
end

Then /^I should see the ([^\"]*) in the ([^\"]*)$/ do |inside_section_name, wrapper_section_name|
  response.should have_xpath(xpath_of_section(wrapper_section_name)) do |wrapper_section|
    wrapper_section.should have_xpath(xpath_of_section(inside_section_name))
  end
end

Then /^I should not see "([^\"]*)" in the (.*)$/ do |text, section_name|
  response.should_not have_xpath("#{xpath_of_section(section_name)}//*[contains(., '#{text}')]")
end
