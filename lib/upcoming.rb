require 'ostruct'
require 'uri'
require 'net/http'
require 'hpricot'

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
    
    # TODO Call the API
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
