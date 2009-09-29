class PagesController < ApplicationController
  caches_page :index
  
  def index
  end 

  def show
    @page = Page.find(:first, :conditions => {:slug => params[:slug]})
    @latest_youtube_vid_url = Hpricot(open('http://gdata.youtube.com/feeds/api/users/learnrevolution/uploads?orderby=updated'))
    @latest_youtube_vid_url = (@latest_youtube_vid_url/'entry')[0].at('media:content').attributes['url']
    render_404 if @page.nil?
  end

  def news
    require 'open-uri'
    # this needs to be given accessors to make it easier to iterate through
    @ningfeed = Hpricot(open('http://thelearningrevolution.ning.com/profiles/blog/feed?user=3eyqtja9xnzhb&xn_auth=no'))
    @ningfeed = (@ningfeed/'entry')[0..7]
    @latest_youtube_vid_url = Hpricot(open('http://gdata.youtube.com/feeds/api/users/learnrevolution/uploads?orderby=updated'))
    @latest_youtube_vid_url = (@latest_youtube_vid_url/'entry')[0].at('media:content').attributes['url']
  end
end
