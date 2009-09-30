Given /^the default "([^\"]*)" page$/ do |page|
  Page.create!(:slug => page.downcase.gsub(' ', '-'), :title => page, :content => File.read("#{RAILS_ROOT}/db/page_contents/#{page.downcase.gsub(' ', '-')}.html"))
end

