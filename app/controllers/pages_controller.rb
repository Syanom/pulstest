class PagesController < ApplicationController
  before_action :find_page, only: %i[show edit update]
  before_action :validate_route, only: %i[show edit update]

  def index
    @page_hierarchies = Page.root.map(&:hierarchy)
  end

  def show
    @hierarchy = @page.hierarchy
  end

  def edit
    Rails.logger.info("\nedit action triggered\n")
  end

  def update
    Rails.logger.info("\nupdate action triggered\n")
  end

  private

  def find_page
    @page = Page.find_by(name: params[:pages].split('/').last)
  end

  def validate_route
    # I decided to check if the client knew the exact page hierarchy to access it.
    raise ActionController::RoutingError, 'Not Found' unless @page&.path == params[:pages]
  end
end
