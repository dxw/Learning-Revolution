# Pages

Page.create!(:slug => "about", :title => "About", :content => File.read("#{RAILS_ROOT}/db/page_contents/about.html")) unless Page.find(:all, :conditions => {:slug => 'about'}).size > 0
Page.create!(:slug => "terms-conditions", :title => "Terms and Conditions", :content => File.read("#{RAILS_ROOT}/db/page_contents/terms-and-conditions.html")) unless Page.find(:all, :conditions => {:slug => 'terms-conditions'}).size > 0
Page.create!(:slug => "privacy-policy", :title => "Privacy Policy", :content => File.read("#{RAILS_ROOT}/db/page_contents/privacy-policy.html")) unless Page.find(:all, :conditions => {:slug => 'privacy-policy'}).size > 0
Page.create!(:slug => "promote-your-event", :title => "Promote Your Event", :content => File.read("#{RAILS_ROOT}/db/page_contents/promote-your-event.html")) unless Page.find(:all, :conditions => {:slug => 'promote-your-event'}).size > 0
Page.create!(:slug => "frequently-asked-questions", :title => "Frequently Asked Questions", :content => File.read("#{RAILS_ROOT}/db/page_contents/frequently-asked-questions.html"))  unless Page.find(:all, :conditions => {:slug => 'frequently-asked-questions'}).size > 0
Page.create!(:slug => "copyright", :title => "Copyright", :content => File.read("#{RAILS_ROOT}/db/page_contents/copyright.html")) unless Page.find(:all, :conditions => {:slug => 'copyright'}).size > 0

# Sample events

rake = Rake::Application.new
Rake.application = rake
Rake::Task.define_task(:environment)
load RAILS_ROOT+"/lib/tasks/lr.rake"
rake['lr:import'].invoke(RAILS_ROOT+"/lib/tasks/sample_data/sample.csv")
