module LocationSpecHelper

  def self.new(options={})
    Location.new(
      {      
        :name => "Venue name",
        :postcode => "A1 1AA",
        :address_1 => "Address line 1",
        :address_2 => "Address line 2",
        :address_3 => "Address line 3",
        :city => "City",
        :county => "County",
        :postcode => "E11 1PB"
      }.merge(options)
    )
  end
  
  def self.save(options={})
    r = self.new(options)
    r.save!
    r
  end

end
