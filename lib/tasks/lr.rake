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
        
        v = Venue.find(:first, :conditions => {:name => row["EventAddress1"],
                       :address_1 => row["EventAddress1"],
                       :address_2 => row["EventAddress2"],
                       :address_3 => row["EventAddress3"],
                       :city => row["EventTown"],
                       :county => nil,
                       :postcode => row["EventPostCode"]})
        unless v
          v = Venue.new
          v.name      = row["EventAddress1"]
          v.address_1 = row["EventAddress1"]
          v.address_2 = row["EventAddress2"]
          v.address_3 = row["EventAddress3"]
          v.city      = row["EventTown"]
          v.county    = nil # Only providing IDs currently
          v.postcode  = row["EventPostCode"]
          v.save!
        end
        
        e = Event.new
        e.venue = v
        e.title = row["ActivityTitle"]
        e.description = row["EventDetails"]
        e.theme = 'TheCoolTheme'
        e.event_type = 'CoolType'
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
        v = Venue.find(:first, :conditions => {:name => row["ADDRESS1"],
                       :address_1 => row["ADDRESS2"] ? row["ADDRESS2"] : 'Blank',
                       :address_2 => row["ADDRESS3"],
                       :address_3 => row["ADDRESS4"],
                       :county => "Norfolk",
                       :postcode => row["POSTCODE"].blank? ? 'NO5 1DE' : row["POSTCODE"]})
        unless v
          v = Venue.new
          v.name = row["ADDRESS1"]
          v.address_1 = row["ADDRESS2"].blank? ? 'Blank' : row["ADDRESS2"]
          v.address_2 = row["ADDRESS3"] unless row["ADDRESS3"] == 'Norfolk'
          v.address_3 = row["ADDRESS4"] unless row["ADDRESS4"] == 'Norfolk'
          v.postcode = row["POSTCODE"].blank? ? 'NO5 1DE' : row["POSTCODE"]
          v.county = "Norfolk"
          v.save!
        end

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
        p "saved #{e.title}, id: #{e.id}" unless RAILS_ENV=='test'
      end
    end

    task :fol => :environment do
      require 'fastercsv'
      FasterCSV.foreach(RAILS_ROOT+"/lib/tasks/data/Festival of Learning Events.csv", :headers => :first_row) do |row|
        #"Timestamp","Title","Postcode","Category","Event type","Description","From","To","Organisation","Contact name","Contact phone number","Contact Email address"
        v = Venue.find(:first, :conditions => {:name => "No Name",
                       :postcode => row["Postcode"]})
        unless v
          v = Venue.new
          v.name = "No Name"
          v.address_1 = "No Address 1"
          v.postcode = row["Postcode"]
          v.save!
        end

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
        p "saved #{e.title}, id: #{e.id}" unless RAILS_ENV=='test'
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
        v = Venue.find(:first, :conditions => {:name => row["EventAddress1"] ? row["EventAddress1"] : 'No Name',
                       :address_1 => row["EventAddress2"].blank? ? 'Blank' : row["EventAddress2"],
                       :address_2 => row["EventAddress3"],
                       :county => row["EventTown"],
                       :postcode => row["EventPostCode"]})
        unless v
          v = Venue.new
          v.name = row["EventAddress1"] ? row["EventAddress1"] : 'No Name'
          v.address_1 = row["EventAddress2"].blank? ? 'Blank' : row["EventAddress2"]
          v.address_2 = row["EventAddress3"]
          v.city = row["EventTown"]
          v.postcode = row["EventPostCode"]
          v.save!
        end

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
        p "saved #{e.title}, id: #{e.id}" unless RAILS_ENV=='test'
      end
    end

    desc "Import some real data"
    task :real_data => [:norfolk, :fol, :flf]

  end

  desc "Import from CSV"
  task(:import, :csv, {:needs => :environment}) do |t,args|
    def str_to_datetime(str)
      date_bits = *str.match(/^(\d{1,2})\/(\d{1,2})\/(\d{2,4}) (\d{2}):(\d{2})/)
      
      if date_bits.nil?
         die "Invalid date format #{str}, expected: dd/mm/yy hh:mm"
      end
      
      Time.zone.local(date_bits[3], date_bits[2], date_bits[1], date_bits[4], date_bits[5])
    end
    def die(msg)
      raise IOError, "csv row ##{@rownum+1}: #{msg}"
    end

    require 'fastercsv'
    @rownum = 0
    ActiveRecord::Base.transaction do
      FasterCSV.foreach(args[:csv], :headers => :first_row) do |row|
        @rownum += 1
        #title,description,cost,min_age,start,end,published,theme,event_type,picture,contact_name,contact_email_address,contact_phone_number,organisation,cyberevent,venue_name,venue_address_1,venue_address_2,venue_address_3,venue_city,venue_county,venue_postcode
        e = Event.new

        if row["cyberevent"].nil? || row["cyberevent"].downcase == "false"
          v = Venue.find(:first, :conditions => {:name => row["venue_name"],
                         :address_1 => row["venue_address_1"],
                         :address_2 => row["venue_address_2"],
                         :address_3 => row["venue_address_3"],
                         :city => row["venue_city"],
                         :county => row["venue_county"],
                         :postcode => row["venue_postcode"]})
          unless v
            v = Venue.new
            v.name = row["venue_name"]
            v.address_1 = row["venue_address_1"]
            v.address_2 = row["venue_address_2"]
            v.address_3 = row["venue_address_3"]
            v.city = row["venue_city"]
            v.county = row["venue_county"]
            v.postcode = row["venue_postcode"]
            if v.invalid?
              die "Venue fails validation for the following reasons: #{v.errors.full_messages.join(", ")}"
            end
          end
          e.venue = v
          v.save!
        elsif row["cyberevent"].downcase == "true"
          %w[venue_name venue_address_1 venue_address_2 venue_address_3 venue_city venue_county venue_postcode].each{|f|
         #   unless row[f].blank?
         #     die 'All venue_* columns MUST be blank if cyberevent is set to "true"'
         #   end
          }
        
        end

        e.provider = row["provider"]

        e.title = row["title"]
        e.description = row["description"]
        e.cost = row["cost"]
        e.min_age = row["min_age"]
        die "start cannot be blank" if row["start"].blank?
        e.start = str_to_datetime(row["start"])
        
        unless row["end"].blank?
          e.end = str_to_datetime(row["end"])
          die "Events cannot end before they have started (#{e.end} < #{e.start})" if e.end < e.start
        end
        
        die "You cannot import events that aren't in October 2009" if e.start.month != 10 || e.start.year != 2009

        if row["published"].nil? || row["published"].downcase == "false"
          e.published = false
        elsif row["published"].downcase == "true"
          e.published = true
        end
        
        e.theme = row["theme"]
        e.event_type = row["event_type"]
        e.picture = row["picture"]
        e.contact_name = row["contact_name"]
        e.contact_email_address = row["contact_email_address"]
        e.contact_phone_number = row["contact_phone_number"]
        e.organisation = row["organisation"]
        
        e.contact_name = 'Not Supplied' if e.contact_name.nil? || e.contact_name.empty?
        e.contact_email_address = 'notsupplied@example.com' if e.contact_email_address.nil? || e.contact_email_address.empty?
      
        e.more_info = row["more_info"]
        
        if row["booking required"].nil? || row["booking required"].downcase == "false"
          e.booking_required = false
        elsif row["booking required"].downcase == "true"
          e.booking_required = true
        end
        
        if e.invalid?
          die "Event fails validation for the following reasons: #{e.errors.full_messages.join(", ")}"
        end

        if e.save!
          p "saved #{e.class}, id #{e.id}, row #{@rownum}" unless RAILS_ENV=='test'
        else
          die "save failed"
        end
      end
    end
  end
  
  namespace :upcoming do
    task :post_pending => :environment do
      Event.post_pending_to_upcoming!
    end
  end
end
