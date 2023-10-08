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
      render :edit
    end
  end

  def new
    @page = Page.new
  end

  def create
    if params[:pages]
      parent_page = find_page
      validate_route
    end
    @page = Page.new(page_params.merge(parent_page_id: parent_page&.id))

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
    return unless params[:pages]

    @page = Page.find_by(name: params[:pages].split('/').last)
    @page || (raise ActionController::RoutingError, 'Not Found')
  rescue StandardError
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def validate_route
    # I decided to check if the client knew the exact page hierarchy to access it.
    raise ActionController::RoutingError, 'Not Found' unless @page&.path == params[:pages]
  rescue StandardError
    render file: "#{Rails.root}/public/404", status: :not_found
  end
end
