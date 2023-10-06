class PagesController < ApplicationController
  def index
    @page_hierarchies = Page.root.map(&:hierarchy)
  end

  def show
    @page = Page.find_by(name: params[:pages].split('/').last)
    # I decided to check if the client knew the exact page hierarchy to access it.
    raise ActionController::RoutingError, 'Not Found' unless @page.path == params[:pages]

    @hierarchy = @page.hierarchy
  end
end
