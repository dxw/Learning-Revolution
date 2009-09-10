class Admin::PagesController < Admin::AdminController
  def index
    @pages = Page.all
  end
  def edit
    @page = Page.find(params[:id])
  end
  def update
    page = Page.find(params[:id])
    page[:title] = request.params[:page][:title]
    page[:slug] = request.params[:page][:slug]
    page[:content] = request.params[:page][:content]
    page.save

    return_or_redirect_to :action => :index
    flash[:page] = "Page saved successfully"
  end
end
