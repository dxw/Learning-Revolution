Page.create!(:slug => "about", :title => "About", :content => "<p>About</p>") unless Page.find(:all, :conditions => {:slug => 'about'}).size > 0
Page.create!(:slug => "terms-conditions", :title => "Terms and Conditions", :content => "<p>Terms</p>") unless Page.find(:all, :conditions => {:slug => 'terms-conditions'}).size > 0
Page.create!(:slug => "privacy", :title => "Privacy", :content => "<p>Privacy</p>") unless Page.find(:all, :conditions => {:slug => 'privacy'}).size > 0
Page.create!(:slug => "promote-your-event", :title => "Promote Your Event", :content => "<p>Promote</p>") unless Page.find(:all, :conditions => {:slug => 'promote-your-event'}).size > 0
Page.create!(:slug => "frequently-asked-questions", :title => "Frequently Asked Questions", :content => "<p>FAQ</p>")  unless Page.find(:all, :conditions => {:slug => 'frequently-asked-questions'}).size > 0
Page.create!(:slug => "copyright", :title => "Copyright", :content => "<p>Copyright</p>") unless Page.find(:all, :conditions => {:slug => 'copyright'}).size > 0
