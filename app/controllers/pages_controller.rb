class PagesController < ApplicationController
  before_action :find_page, only: %i[show edit update]
  before_action :validate_route, only: %i[show edit update]

  def index
    @page_hierarchies = Page.root.map(&:hierarchy)
  end

  def show
    @hierarchy = @page.hierarchy
  end

  def edit; end

  def update
    if @page.update(page_params)
      redirect_to page_path(@page.path)
    else
      # Use find_page because .update overwrite @page and breaks routes
      redirect_to edit_page_path(find_page.path)
    end
  end

  private

  def page_params
    params.require(:page).permit(:name, :content_raw)
  end

  def find_page
    @page = Page.find_by(name: params[:pages].split('/').last)
    @page || (raise ActionController::RoutingError, 'Not Found')
  end

  def validate_route
    # I decided to check if the client knew the exact page hierarchy to access it.
    raise ActionController::RoutingError, 'Not Found' unless @page&.path == params[:pages]
  end
end
