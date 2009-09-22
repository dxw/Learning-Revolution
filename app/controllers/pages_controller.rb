class PagesController < ApplicationController
  caches_page :index
  
  def index
  end 

  def show
    @page = Page.find(:first, :conditions => {:slug => params[:slug]})
    if @page.nil?
      @status = 404
      render :template => 'error', :status => 404
    end
  end

  def news
    require 'open-uri'
    # this needs to be given accessors to make it easier to iterate through
    @ningfeed = Hpricot(open('http://thelearningrevolution.ning.com/profiles/blog/feed?xn_auth=no'))
    @ningfeed = (@ningfeed/'entry')[0..7]
  end
end
