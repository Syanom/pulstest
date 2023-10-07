class PagesController < ApplicationController
  # I don't use except instead of only, except can lead to troubles later
  before_action :find_page, only: %i[show edit update new create]
  before_action :validate_route, only: %i[show edit update new create]

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
      render :edit
    end
  end

  def new
    # Callbacks will find and validate parent page for us. We want validation
    # We redefine @page to not have parant page params prefilled for new one
    @page = Page.new
    render :edit
  end

  def create
    # Callbacks will find and validate parent page for us. We use it to create new page
    @page = Page.new(page_params.merge(parent_page_id: @page.id))
    if @page.save
      redirect_to page_path(@page.path)
    else
      render :new
    end
  end

  private

  def page_params
    params.require(:page).permit(:name, :content_raw, :header)
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
