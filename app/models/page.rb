class Page < ApplicationRecord
  belongs_to :parent_page, class_name: 'Page', foreign_key: 'parent_page_id', optional: true
  has_many :child_pages, class_name: 'Page', foreign_key: 'parent_page_id', dependent: :nullify

  scope :root, -> { where(parent_page_id: nil) }

  # Returns relative path to page according to our routing system
  def path
    "#{parent_page&.path}/#{name}"
  end

  # Returns hierarchy tree for rendering
  def hierarchy
    { name: name, path: path, pages: child_pages.map { |page| page.hierarchy } }
  end
end
