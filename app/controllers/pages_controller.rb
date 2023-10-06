class PagesController < ApplicationController
  def index
    @page_hierarchies = Page.root.map { |page| page.get_hierarchy }
  end

  def show
    @page = Page.find_by(name: params[:pages].split('/').last)
    @hierarchy = @page.get_hierarchy
  end
end
