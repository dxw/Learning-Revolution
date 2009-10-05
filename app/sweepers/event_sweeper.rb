class EventSweeper < ActionController::Caching::Sweeper

  observe Event, Venue

  def after_create(post)
    expire_cache_for(post)
  end

  def after_update(post)
    expire_cache_for(post)
  end

  def before_update(post)
    # This ensures that when the name or date of an event gets changed, that the old cached page gets removed.
    s = post.start
    expire_page(:controller => '/events', :action => 'show', :year => s.year, :month => s.strftime('%B'), :day => s.day, :id => post.slug)
  end

  def after_destroy(post)
    expire_cache_for(post)
  end

  private
  def expire_cache_for(record)
    if record.is_a? Event or record.is_a? Venue
      expire_events
    end
    expire_page(:controller => '/pages', :action => 'index')
    expire_page(:controller => '/events', :action => 'index', :year => 2009, :month => 'October')
    Rails.cache.clear
  end

  def expire_events
    Event.all.each do |event|
      %w[atom ics html].map{|f|f.to_sym}.each do |format|
        expire_page(:controller => '/events', :action => 'show', :year => event.start.year, :month => event.start.strftime('%B'), :day => event.start.day, :id => event.slug, :format => format)
      end
    end
  end
end
