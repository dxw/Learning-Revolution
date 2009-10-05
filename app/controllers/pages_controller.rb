class PagesController < ApplicationController
  caches_page :index, :show, :news
  
  def index
  end 

  def show
    @page = Page.find(:first, :conditions => {:slug => params[:slug]})
    
    latest_youtube_vid_url
   
    render_404 if @page.nil?
  end

  def news
    require 'open-uri'

    # this needs to be given accessors to make it easier to iterate through
    ning_uri = 'http://thelearningrevolution.ning.com/profiles/blog/feed?user=3eyqtja9xnzhb&xn_auth=no'

    begin
      @ningfeed = Hpricot(open(ning_uri))
      @ningfeed = (@ningfeed/'entry')[0..7]
    rescue Object => e
      Notifier.deliver_error_notification('Unable to load ning feed at #{ning_uri}', e, request)
    end

    latest_youtube_vid_url
  end

  def latest_youtube_vid_url
    require 'open-uri'

    return @latest_youtube_vid_url if @latest_youtube_vid_url != nil
    
    begin
      feed_uri = 'http://gdata.youtube.com/feeds/api/users/learnrevolution/uploads?orderby=updated'
      youtube_feed = Hpricot(open(feed_uri))
      @latest_youtube_vid_url = (youtube_feed/'entry')[0].at('media:content').attributes['url'].gsub('&', '&amp;')
    rescue Object => e
      Notifier.deliver_error_notification('Unable to load youtube video feed at #{feed_uri}', e, request)
    end
  end
end
