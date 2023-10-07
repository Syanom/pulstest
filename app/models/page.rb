class Page < ApplicationRecord
  belongs_to :parent_page, class_name: 'Page', foreign_key: 'parent_page_id', optional: true
  has_many :child_pages, class_name: 'Page', foreign_key: 'parent_page_id', dependent: :nullify

  validates_format_of :name, with: /\A[a-zA-Z0-9_А-Яа-я]+\z/, message: 'must contain only: _ A-z А-я 0-9'
  # I duplicate this in database migration in case of we have multiple sources of pages
  validates_uniqueness_of :name, message: 'must be unique'
  validates :name, exclusion: { in: %w[edit add], message: 'must NOT be edit or add' }

  scope :root, -> { where(parent_page_id: nil) }

  # Returns relative path to page according to our routing system
  def path
    "#{parent_page&.path&.+ '/'}#{name}"
  end

  # Returns hierarchy tree for rendering
  def hierarchy
    { name: name, path: path, pages: child_pages.map { |page| page.hierarchy } }
  end
end
