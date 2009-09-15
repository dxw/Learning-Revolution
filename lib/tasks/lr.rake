namespace :lr do 
  namespace :dev do
    task :seed => :environment do
      venue = Venue.create!(:name => "The Lido", :address_1 => "1 Berrick Street", :city => "London", :postcode => "N1 1AA")
      
      Event.create!(:venue => venue, :title => "Open Yoga sessions", :featured => true, :published => true, :picture => "http://farm3.static.flickr.com/2343/1969404337_2eecb3bbb2.jpg", :start => "1 october 2009".to_time)
      Event.create!(:venue => venue, :title => "Photography course", :featured => true, :published => true, :picture => "http://farm4.static.flickr.com/3080/3210572714_d6f9440846.jpg", :start => "2 october 2009".to_time)
      Event.create!(:venue => venue, :title => "Archery training", :featured => true, :published => true, :picture => "http://farm4.static.flickr.com/3080/3210572714_d6f9440846.jpg", :start => "2 october 2009".to_time)
      Event.create!(:venue => venue, :title => "Needlework", :featured => true, :published => true, :picture => "http://farm4.static.flickr.com/3080/3210572714_d6f9440846.jpg", :start => "2 october 2009".to_time)
    end
    
    task :mass_seed => :environment do
      require 'lib/tasks/data/postcodes.rb'
      venues = []
      300.times do |id|
        venues << Venue.create!(:name => "School Hall #{id}", :address_1 => "#{id} Berrick Street", :city => "London", :postcode => POSTCODES[rand(POSTCODES.size)])
        p "Created venue #{id}"
      end
      150.times do |id|
        31.times do |day|
          Event.create!(:venue => venues[rand(venues.size)], :title => "Open Yoga sessions #{id}", :theme => Event::Themes[rand(Event::Themes.size)], :event_type => Event::Types[rand(Event::Types.size)], :published => true, :start => "#{day+1} october 2009".to_time, :contact_name => "James Darling", :contact_phone_number => "07811407085")
          p "Created event #{id}"
        end
      end
    end
    
    task :seed_demo_data => :environment do
      require 'fastercsv'
      FasterCSV.foreach(RAILS_ROOT+"/lib/tasks/data/CFL-sample-data.csv", :headers => :first_row) do |row|
        
        v = Venue.new
        v.name      = row["EventAddress1"]
        v.address_1 = row["EventAddress1"]
        v.address_2 = row["EventAddress2"]
        v.address_3 = row["EventAddress3"]
        v.city      = row["EventTown"]
        v.county    = nil # Only providing IDs currently
        v.postcode  = row["EventPostCode"]
        v.save!
        
        e = Event.new
        e.venue = v
        e.title = row["ActivityTitle"]
        e.description = row["EventDetails"]
        e.theme = 'TheCoolTheme'
        e.event_type = 'CoolType'
        e.stage = nil
        e.start = Date.parse(row["EventDate"]) if row["EventDate"]
        e.end = nil
        e.cost = row["Cost"]
        e.min_age = nil
        e.organisation = nil
        e.contact_name = row["ContactNamePublic"] ? row["ContactNamePublic"] : 'NoName'
        e.contact_phone_number = row["TelephonePublic"]
        e.contact_email_address = 'anonymous@example.com' unless e.contact_phone_number
        e.published = true
        e.picture = nil
        e.featured = false
        e.save!
        p "saved #{e.title}, id: #{e.id}"
      end
    end

    task :norfolk => :environment do
      require 'fastercsv'
      FasterCSV.foreach(RAILS_ROOT+"/lib/tasks/data/Norfolk event data.csv", :headers => :first_row) do |row|
        #"Code","Name","StartDate","NoOfWeeks","StartTime","ADDRESS1","ADDRESS2","ADDRESS3","ADDRESS4","POSTCODE"
        v = Venue.new
        v.name = row["ADDRESS1"]
        v.address_1 = row["ADDRESS2"]
        v.address_2 = row["ADDRESS3"]
        v.address_3 = row["ADDRESS4"]
        v.postcode = row["POSTCODE"].blank? ? 'NO5 1DE' : row["POSTCODE"]
        v.county = "Norfolk"
        v.save!

        e = Event.new
        e.venue = v
        e.title = row["Name"]
        e.theme = 'NorfolkData'
        e.event_type = 'NorfolkType'
        day, month, year = row["StartDate"].strip.split('/').map{|a|a.to_i}
        hour, minute = row["StartTime"].strip.split(':').map{|a|a.to_i}
        e.start = Time.zone.local(year, month, day) + hour.hours + minute.minutes
        e.end = e.start + row["NoOfWeeks"].to_i.weeks
        e.contact_name = "Nobody"
        e.contact_phone_number = "000"
        e.contact_email_address = "nobody@example.com"
        e.published = true
        e.save!
        p "saved #{e.title}, id: #{e.id}"
      end
    end
      
  end
end
