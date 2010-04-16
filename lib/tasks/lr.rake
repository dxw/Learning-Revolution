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

    skip = 0

    ActiveRecord::Base.transaction do
      FasterCSV.foreach(args[:csv], :headers => :first_row) do |row|
        @rownum += 1

        if @rownum < skip
          puts "Skipping #{@rownum}"
          next
        end

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

  namespace :email_subscriptions do
    desc "Deliver emails"
    task :deliver => :environment do
      EmailSubscription.deliver_all_updates!
    end
  end

  task(:clear_identical, :csv, {:needs => :environment}) do |t,args|
    ActiveRecord::Base.transaction do
      # Fix events where the possible_duplicate exists but is broken
      duplicate_events = Event.find(:all, :conditions => "possible_duplicate_id IS NOT NULL AND (not_a_dup != TRUE OR not_a_dup IS NULL)")
      duplicate_events.select{|e|e.possible_duplicate.blank?}.each{|e|
        e.possible_duplicate = nil
        e.not_a_dup = true
        e.save!
        puts "Fixing possible_duplicate_id/not_a_dup on Event #{e.id}"
      }
      # Fix venues where the possible_duplicate exists but is broken
      duplicate_venues = Venue.find(:all, :conditions => "possible_duplicate_id IS NOT NULL AND (not_a_dup != TRUE OR not_a_dup IS NULL)")
      duplicate_venues.select{|v|v.possible_duplicate.blank?}.each{|v|
        v.possible_duplicate = nil
        v.not_a_dup = true
        v.save!
        puts "Fixing possible_duplicate_id/not_a_dup on Venue #{e.id}"
      }
      # Find all events which have identical twins
      duplicate_events = Event.find(:all, :conditions => "possible_duplicate_id IS NOT NULL AND (not_a_dup != TRUE OR not_a_dup IS NULL)")
      duplicate_events.each{|e|
        next if e.title != e.possible_duplicate.title
        next if e.description != e.possible_duplicate.description
        next if e.theme != e.possible_duplicate.theme
        next if e.event_type != e.possible_duplicate.event_type
        next if e.start != e.possible_duplicate.start
        next if e.end != e.possible_duplicate.end
        next if e.cost != e.possible_duplicate.cost
        next if e.min_age != e.possible_duplicate.min_age
        next if e.organisation != e.possible_duplicate.organisation
        next if e.contact_name != e.possible_duplicate.contact_name
        next if e.contact_phone_number != e.possible_duplicate.contact_phone_number
        next if e.contact_email_address != e.possible_duplicate.contact_email_address
        next if e.published != e.possible_duplicate.published
        next if e.picture != e.possible_duplicate.picture
        next if e.featured != e.possible_duplicate.featured
        #next if e.created_at != e.possible_duplicate.created_at
        #next if e.updated_at != e.possible_duplicate.updated_at
        #next if e.possible_duplicate_id != e.possible_duplicate.possible_duplicate_id
        next if e.lat != e.possible_duplicate.lat
        next if e.lng != e.possible_duplicate.lng
        #next if e.bitly_url != e.possible_duplicate.bitly_url
        next if e.provider != e.possible_duplicate.provider
        next if e.more_info != e.possible_duplicate.more_info
        next if e.booking_required != e.possible_duplicate.booking_required
        #next if e.not_a_dup != e.possible_duplicate.not_a_dup

        next if e.venue.name != e.possible_duplicate.venue.name
        next if e.venue.address_1 != e.possible_duplicate.venue.address_1
        next if e.venue.address_2 != e.possible_duplicate.venue.address_2
        next if e.venue.address_3 != e.possible_duplicate.venue.address_3
        next if e.venue.city != e.possible_duplicate.venue.city
        next if e.venue.county != e.possible_duplicate.venue.county
        next if e.venue.postcode != e.possible_duplicate.venue.postcode
        #next if e.venue.created_at != e.possible_duplicate.venue.created_at
        #next if e.venue.updated_at != e.possible_duplicate.venue.updated_at
        #next if e.venue.possible_duplicate_id != e.possible_duplicate.venue.possible_duplicate_id
        next if e.venue.type != e.possible_duplicate.venue.type
        next if e.venue.lat != e.possible_duplicate.venue.lat
        next if e.venue.lng != e.possible_duplicate.venue.lng
        #next if e.venue.not_a_dup != e.possible_duplicate.venue.not_a_dup

        e.delete
        puts "Deleting identical twin Event #{e.id}"
      }

    end
  end
  desc "Post stuff to Upcoming"
  namespace :upcoming do
    task :post_pending => :environment do
      Event.post_pending_to_upcoming!
    end
  end
  desc "Move Q (query string) to new theme T (string)"
  task(:move_to_theme, {:needs => :environment}) do |t,args|
    raise ArgumentError, 'Set the query string (i.e. rake lr:move_to_theme Q=foo)' if ENV['Q'].blank?
    raise ArgumentError, 'Set the theme name (i.e. rake lr:move_to_theme T=theme)' if ENV['T'].blank?
    a = "%#{ENV['Q']}%"
    arr = []
    cond = %w[title description theme event_type cost min_age organisation contact_name contact_phone_number contact_email_address].map{|field|arr<<a;"#{field} LIKE ?"}.join(' OR ')
    events = Event.find(:all, :conditions => [cond]+arr, :order => 'start, title')
    ActiveRecord::Base.transaction do
      events.each do |event|
        event.theme = ENV['T']
        event.save!
      end
    end
  end
end
