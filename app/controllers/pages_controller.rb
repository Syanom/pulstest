class PagesController < ApplicationController
  def index
    @page_hierarchies = Page.root.map { |page| page.get_hierarchy }
  end
end
