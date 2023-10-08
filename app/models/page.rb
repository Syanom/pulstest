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
    Page.join_recursive do |query|
      query
        .start_with(id: id) { select('0 depth') }
        .select(query.prior[:depth] - 1, start_with: false)
        .connect_by(parent_page_id: :id)
    end.order('depth ASC').pluck(:name).join('/')
  end

  # Returns hierarchy tree for rendering
  def hierarchy
    # get whole hierarchy and group for future use
    pages = Page.join_recursive do |query|
      query.start_with(parent_page_id: id)
           .connect_by(id: :parent_page_id)
    end.group_by(&:parent_page_id)

    { name: name, path: path, pages: pages[id] ? hasify_children(pages, id, "#{path}/") : [] }
  end

  protected

  def hasify_children(pages, parent_id, parent_path)
    pages[parent_id].map do |page|
      { name: page.name, path: "#{parent_path}#{page.name}",
        pages: pages[page.id] ? hasify_children(pages, page.id, "#{parent_path}#{page.name}/") : [] }
    end
  end
end
