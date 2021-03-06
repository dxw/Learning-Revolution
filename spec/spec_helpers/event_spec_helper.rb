module EventSpecHelper

  def self.new(options={})

    e = Event.new(self.valid_attributes(options))

    e.stub!(:make_bitly_url)

    e
  end

  def self.save(options={})
    r = self.new(options)
    r.save!
    r
  end

  def self.valid_attributes(options={})
    {
        :title => "value for title",
        :description => "value for description",
        :theme => "value for theme",
        :event_type => "value for type",
        :start => Time.now,
        :end => Time.now,
        :cost => "value for cost",
        :min_age => 1,
        :organisation => "value for organisation",
        :contact_name => "value for contact_name",
        :contact_phone_number => "value for contact_phone_number",
        :contact_email_address => "contact_email_address@example.com",
        :published => true,
        :picture => "value for picture",
        :featured => false,
        :venue => VenueSpecHelper.new
      }.merge(options)
  end

end
