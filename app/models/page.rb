class Page < ApplicationRecord
  belongs_to :parent_page, class_name: 'Page', foreign_key: 'parent_page_id', optional: true
  has_many :child_pages, class_name: 'Page', foreign_key: 'parent_page_id', dependent: :nullify

  scope :root, -> { where(parent_page_id: nil) }

  # Returns relative path to page according to our routing system
  def get_path
    "#{parent_page.get_path if parent_page}/#{name}"
  end

  # Returns hierarchy tree for rendering
  def get_hierarchy
    { name: name, path: get_path, pages: child_pages.map { |page| page.get_hierarchy } }
  end
end
