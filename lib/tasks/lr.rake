namespace :lr do 
  namespace :dev do
    task :seed => :environment do
      venue = Venue.create!(:name => "The Lido", :address_1 => "1 Berrick Street", :city => "London", :postcode => "N1 1AA")
      
      Event.create!(:theme => 'Theme', :contact_phone_number => '01234', :event_type => 'Type', :contact_name => 'Tom', :contact_email_address => 'tom@thedextrousweb.com', :venue => venue, :title => "Open Yoga sessions", :featured => true, :published => true, :picture => "http://farm3.static.flickr.com/2343/1969404337_2eecb3bbb2.jpg", :start => "1 october 2009".to_time)
      Event.create!(:theme => 'Theme', :contact_phone_number => '01234', :event_type => 'Type', :contact_name => 'Tom', :contact_email_address => 'tom@thedextrousweb.com', :venue => venue, :title => "Photography course", :featured => true, :published => true, :picture => "http://farm4.static.flickr.com/3080/3210572714_d6f9440846.jpg", :start => "2 october 2009".to_time)
      Event.create!(:theme => 'Theme', :contact_phone_number => '01234', :event_type => 'Type', :contact_name => 'Tom', :contact_email_address => 'tom@thedextrousweb.com', :venue => venue, :title => "Archery training", :featured => true, :published => true, :picture => "http://farm4.static.flickr.com/3080/3210572714_d6f9440846.jpg", :start => "2 october 2009".to_time)
      Event.create!(:theme => 'Theme', :contact_phone_number => '01234', :event_type => 'Type', :contact_name => 'Tom', :contact_email_address => 'tom@thedextrousweb.com', :venue => venue, :title => "Needlework", :featured => true, :published => true, :picture => "http://farm4.static.flickr.com/3080/3210572714_d6f9440846.jpg", :start => "2 october 2009".to_time)
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
        e.contact_phone_number = '01234' if e.contact_phone_number.blank?
        e.contact_email_address = 'anonymous@example.com'
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
        v.address_1 = row["ADDRESS2"] unless row["ADDRESS2"] == 'Norfolk'
        v.address_2 = row["ADDRESS3"] unless row["ADDRESS3"] == 'Norfolk'
        v.address_3 = row["ADDRESS4"] unless row["ADDRESS4"] == 'Norfolk'
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
        e.featured = false
        e.save!
        p "saved #{e.title}, id: #{e.id}"
      end
    end

    task :fol => :environment do
      require 'fastercsv'
      FasterCSV.foreach(RAILS_ROOT+"/lib/tasks/data/Festival of Learning Events.csv", :headers => :first_row) do |row|
        #"Timestamp","Title","Postcode","Category","Event type","Description","From","To","Organisation","Contact name","Contact phone number","Contact Email address"
        v = Venue.new
        v.name = "No Name"
        v.postcode = row["Postcode"]
        v.save!

        e = Event.new
        e.venue = v
        e.title = row["Title"]
        e.theme = row["Category"]
        e.event_type = row["Event type"]
        e.description = row["Description"]
        e.organisation = row["Organisation"]
        if row["From"].include? "/"
          day, month, year = row["From"].strip.split('/').map{|a|a.to_i}
          e.start = Time.zone.local(year, month, day)
        else
          e.start = Time.zone.parse(row["From"])
        end
        if row["To"].include? "/"
          day, month, year = row["To"].strip.split('/').map{|a|a.to_i}
          e.end = Time.zone.local(year, month, day)
        else
          e.end = Time.zone.parse(row["To"])
        end
        e.contact_name = row["Contact name"]
        e.contact_phone_number = row["Contact phone number"]
        e.contact_email_address = row["Contact Email address"]
        e.published = true
        e.featured = false
        e.save!
        p "saved #{e.title}, id: #{e.id}"
      end
    end

    task :flf => :environment do
      require 'fastercsv'
      csv = open(RAILS_ROOT+"/lib/tasks/data/cf-flf-events-to-13sept.csv").read
      csv.gsub!("\x92", "\xe2\x80\x99") # Microsoft
      csv.gsub!("\x93", "\xe2\x80\x9c") # smart
      csv.gsub!("\x94", "\xe2\x80\x9d") # quotes
      csv.gsub!("\xa3", "\xc2\xa3") # GBP

      FasterCSV.new(csv, :headers => :first_row).each do |row|
        #ActivityID,ActivityTitle,EventAddress1,EventAddress2,EventAddress3,EventTown,EventCountyID,EventPostCode,EventDetails,TelephonePublic,ContactNamePublic,EventDate,EventTime,BookingRequired,Cost,URL,KeyNum,SitePublishStatus,Active
        v = Venue.new
        v.name = row["EventAddress1"] ? row["EventAddress1"] : 'No Name'
        v.address_1 = row["EventAddress2"]
        v.address_2 = row["EventAddress3"]
        v.city = row["EventTown"]
        v.postcode = row["EventPostCode"]
        v.save!

        e = Event.new
        e.venue = v

        e.start = Time.zone.parse(row["EventDate"])
        t = row["EventTime"]
        unless t.nil?
          begin
            t2 = Time.zone.parse(c)
            e.start = e.start + t2.hour.hours + t2.minute.minutes
          rescue
          end
        end

        e.title = row["ActivityTitle"]
        e.description = row["EventDetails"]
        if e.description.blank?
          e.description = ""
        else
          e.description << "\n\n"
        end
        e.description << "Booking is #{row["BookingRequired"] ? '' : 'not '}required for this event."
        e.description << "\n\nLink: #{row["URL"]}" if row["URL"]

        e.contact_name = row["ContactNamePublic"] ? row["ContactNamePublic"] : 'No Name'
        e.contact_phone_number = row["TelephonePublic"] ? row["TelephonePublic"] : 'No Number'
        e.contact_email_address = "nobody@example.com"
        e.cost = row["Cost"]
        e.event_type = "FalafelType"
        e.theme = "FalafelTheme"
        case row["SitePublishStatus"]
        when "P"
          e.published = true
        when "R"
          e.published = false
        end
        e.featured = false
        e.save!
        p "saved #{e.title}, id: #{e.id}"
      end
    end

    task :real_data => [:norfolk, :fol, :flf]

  end
end
