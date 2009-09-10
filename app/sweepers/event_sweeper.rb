class EventSweeper < ActionController::Caching::Sweeper

  observe Event, Venue

  def after_create(post)
    expire_cache_for(post)
  end

  def after_update(post)
    expire_cache_for(post)
  end

  def after_destroy(post)
    expire_cache_for(post)
  end

  private
  def expire_cache_for(record)

    expire_page(:controller => '/pages', :action => 'index')

    # expire_page(:controller => ‘blog’, :action => ‘show’, :id => record.id)
  end
end