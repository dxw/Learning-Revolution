t = Time.now
host = "http://localhost"
require 'lib/tasks/data/postcodes'
Themes = ["Food and Cookery", "Languages and Travel", "Heritage and History", "Culture, Arts & Crafts", "Music and Performing Arts", "Sport and Physical Activity", "Health and Wellbeing", "Nature & the Environment", "Technology & Broadcasting", "Other"]
Types = ["Class"]

Trample.configure do
  concurrency 1
  iterations  10

  # homepage
  get "#{host}/" do
  end
  # Default calendar view
  get "#{host}/events/2009/October" do
  end
  # Postcode search
  get "http://localhost/events/2009/October?filter[theme]=&filter[event_type]=&view=calendar&filter[location]=:postcode" do
    @postcode = POSTCODES[rand(POSTCODES.size)]
    {:postcode => @postcode.split(" ").join("+")}
  end
  # Same Postcode search
  get "http://localhost/events/2009/October?filter[theme]=&filter[event_type]=&view=calendar&filter[location]=:postcode" do
    {:postcode => @postcode.split(" ").join("+")}
  end
  # Theme and Type search
  get "http://localhost/events/2009/October?filter[theme]=:theme&filter[event_type]=:type&view=calendar&filter[location]=" do
    {:theme => Themes[rand(Themes.size)].split(" ").join("+"), :type => Types[rand(Types.size)].split(" ").join("+")}
  end

end
