require 'ostruct'
require 'uri'
require 'net/http'
require 'hpricot'

# Basic wrapper around the methods necessary to add an event on Upcoming.
# 
# To use, you'll need to add an API key and an auth token to application.yml.
# 
# To get an API key, log into Upcoming using an account to represent the
# developer, and go to:
# 
# http://upcoming.yahoo.com/services/api/keygen.php
#
# Stick it in application.yml.
# 
# Then, to get an auth token, log into Upcoming using a user account that
# you want the posted to events to belong to. Visit:
# 
# http://upcoming.yahoo.com/services/auth/?api_key=<Your API Key>
# 
# Authorise the app, and note the code (AKA the 'frob') that you're given.
# From the Rails console, run:
#
# Upcoming.get_token('<Your frob>')
# 
# and you'll get an object representing the user, the 'token' method
# of which needs to go into application.yml to make the rest of the
# methods work.
# 
# TODO:
# API rate-limiting?
#
module Upcoming
  ENDPOINT = "http://upcoming.yahooapis.com/services/rest/"
  
  # See http://upcoming.yahoo.com/services/api/auth.getToken.php
  def self.get_token(frob)
    data = {'method' => 'auth.getToken', 'api_key' => AppConfig.upcoming_api_key, 'frob' => frob}
    
    token_element = get(data).first
    
    token = OpenStruct.new(
      :token => token_element.attributes['token'],
      :user_id => token_element.attributes['user_id'].to_i,
      :user_username => token_element.attributes['user_username'],
      :user_name => token_element.attributes['user_name']
    )
    token
  end
  
  # See http://upcoming.yahoo.com/services/api/category.getList.php
  def self.get_category_list
    data = {'method' => 'category.getList', 'api_key' => AppConfig.upcoming_api_key}
    
    category_elements = get(data)
    
    category_elements.map do |e|
      OpenStruct.new(
        :category_id => e.attributes['id'].to_i,
        :name => e.attributes['name'],
        :description => e.attributes['description']
      )
    end
  end
  
  # See http://upcoming.yahoo.com/services/api/venue.add.php
  def self.add_venue!(options={})
    # Ensure we have all the required parameters
    [:venuename, :venueaddress, :venuecity, :location].each do |key|
      unless options.has_key?(key)
        raise ArgumentError, "Required parameter #{key.to_s} missing"
      end
    end
    
    # Construct data for POST
    post_data = {'method' => 'venue.add'}
    post_data['api_key'] = AppConfig.upcoming_api_key
    post_data['token'] = AppConfig.upcoming_api_token
    post_data['venuename'] = options[:venuename]
    post_data['venueaddress'] = options[:venueaddress]
    post_data['venuecity'] = options[:venuecity]
    post_data['location'] = options[:location]
    post_data['venuezip'] = options[:venuezip] if options[:venuezip]
    
    # Submit and get response
    venue_element = post(post_data).first
    
    # Turn response into a nice Ruby object
    venue = OpenStruct.new(
      :venue_id => venue_element.attributes['id'].to_i, # Can't use :id since it conflicts with Object#id
      :name => venue_element.attributes['name'],
      :address => venue_element.attributes['address'],
      :city => venue_element.attributes['city'],
      :zip => venue_element.attributes['zip'],
      :url => venue_element.attributes['url'],
      :description => venue_element.attributes['description'],
      :user_id => venue_element.attributes['user_id'].to_i
    )
    venue.private = (venue_element.attributes['private'] == '1') ? true : false
    venue
  end
  
  # See http://upcoming.yahoo.com/services/api/event.add.php
  def self.add_event!(options={})
    # Ensure we have all the required parameters
    [:name, :venue_id, :category_id, :start, :end].each do |key|
      unless options.has_key?(key)
        raise ArgumentError, "Required parameter #{key.to_s} missing"
      end
    end
    
    post_data = {'method' => 'event.add'}
    post_data['api_key'] = AppConfig.upcoming_api_key
    post_data['token'] = AppConfig.upcoming_api_token
    post_data['name'] = options[:name]
    post_data['venue_id'] = options[:venue_id]
    post_data['category_id'] = options[:category_id]
    post_data['start_date'] = options[:start].strftime('%Y-%m-%d')
    post_data['end_date'] = options[:end].strftime('%Y-%m-%d') if options[:end]
    post_data['start_time'] = options[:start].strftime('%H:%M:%S')
    post_data['end_time'] = options[:end].strftime('%H:%M:%S') if options[:end]
    post_data['description'] = options[:description]
    post_data['url'] = options[:url]
    
    event_element = post(post_data).first
    
    event = OpenStruct.new(
      :event_id => event_element.attributes['id'].to_i, # Can't use :id since it conflicts with Object#id
      :name => event_element.attributes['name'],
      :tags => event_element.attributes['tags'],
      :description => event_element.attributes['description'],
      :metro_id => event_element.attributes['metro_id'].to_i,
      :venue_id => event_element.attributes['venue_id'].to_i,
      :user_id => event_element.attributes['user_id'].to_i,
      :category_id => event_element.attributes['category_id'].to_i,
      :ticket_url => event_element.attributes['ticket_url'],
      :ticket_price => event_element.attributes['ticket_price']
    )
    event.start = Time.parse("#{event_element.attributes['start_date']} #{event_element.attributes['start_time']}")
    event.end = Time.parse("#{event_element.attributes['end_date']} #{event_element.attributes['end_time']}")
    
    event.personal = (event_element.attributes['personal'] == '1') ? true : false
    event.selfpromotion = (event_element.attributes['selfpromotion'] == '1') ? true : false
    
    event
  end
  
  def self.get(data={})
    response = Net::HTTP.get_response(URI.parse("#{ENDPOINT}?#{Rack::Utils.build_query(data)}"))
    process_response(response)
  end
  
  def self.post(data={})
    response = Net::HTTP.post_form(URI.parse(ENDPOINT), data)
    process_response(response)
  end
  
  # Takes a Net::HTTPResponse object from an Upcoming API call.
  # 
  # Upcoming API responses come as an XML document with a root element 'rsp',
  # which has a 'stat' attribute containing success or failure.
  # 
  # If the repsonse was successful, process_response returns an array of the
  # XML elements inside the rsp root element, which the individual method
  # wrappers can further process as necessary.
  # 
  # Otherwise, it raises an appropriate exception.
  def self.process_response(response)
    # DEBUG
    Rails.logger.info(response.body)
    
    case response
    when Net::HTTPSuccess
      doc = Hpricot(response.body)
      
      rsp_element = (doc/"rsp").first
      unless rsp_element
        raise FormatError, "Response did not contain rsp element"
      end
      if rsp_element.attributes['stat'] == 'fail'
        error_element = (rsp_element/"error").first
        unless error_element
          raise FormatError, "Received fail response, but with no error message"
        end
        raise ApiError, error_element.attributes['msg']
      end
      
      elements = (doc/"rsp[@stat=ok]/*").reject{|e| e.text?}
      raise FormatError, "Received OK response, but with no data" if elements.empty?
      elements
      
    when Net::HTTPForbidden # 403 Not Authorized
      raise InvalidToken,   "Missing or invalid token"
    when Net::HTTPNotFound  # 404 Not Found
      raise InvalidFrob,    "Missing or invalid frob"
    when Net::HTTPConflict  # 409 Conflict
      raise ApiError,       "Missing or invalid request parameter"
    else
      raise ApiError,       "Unexpected HTTP response code"
    end
  end
  
  class ApiError     < RuntimeError; end
  class FormatError  < ApiError; end
  class InvalidToken < ApiError; end
  class InvalidFrob  < ApiError; end
end
