class Admin::PagesController < Admin::AdminController

  make_resourceful do
    actions :create, :new

    response_for :create do |format|
      format.html do
        flash[:page] = "Page created successfully"
        redirect_to :action => :index
      end
    end
  end

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
