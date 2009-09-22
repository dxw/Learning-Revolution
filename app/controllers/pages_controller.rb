class PagesController < ApplicationController
  caches_page :index
  
  def index
  end 

  def news
    
    require 'hpricot'
    require 'open-uri'
    # this needs to be given accessors to make it easier to iterate through
    @ningfeed = Hpricot(open('http://thelearningrevolution.ning.com/profiles/blog/feed?xn_auth=no'))
    @ningfeed = (@ningfeed/'entry')[0..7]
  end
end
