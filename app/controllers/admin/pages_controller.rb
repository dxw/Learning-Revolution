class Admin::PagesController < Admin::AdminController
  def index
    @pages = Page.all
  end
  def edit
    @page = Page.find(params[:id])
  end
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])

    if @page.save then
      return_or_redirect_to :action => :index
      flash[:page] = "Page saved successfully"
      expire_page :controller => '/pages', :action => 'show', :slug => @page.slug
    else
      render :action => :edit
    end
  end
end
