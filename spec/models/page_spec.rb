require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'ensure presence of name' do
    page = FactoryBot.create(:page)
    page.name = ''
    expect(page).to_not be_valid
  end

  it 'ensure uniqueness of name' do
    page = FactoryBot.create(:page)
    page2 = FactoryBot.create(:page, name: 'page_name2')
    page2.name = page.name
    expect(page2).to_not be_valid
  end

  it "ensure that page's name is NOT equal to add, edit" do
    page = FactoryBot.create(:page)
    page.name = 'add'
    expect(page).to_not be_valid
    page.name = 'edit'
    expect(page).to_not be_valid
  end

  it 'supports cyrillic names' do
    page = FactoryBot.create(:page)
    page.name = 'имя_страницы'
    expect(page).to be_valid
  end

  it 'restricts spaces and symbols' do
    page = FactoryBot.create(:page)
    page.name = 'имя страницы'
    expect(page).to_not be_valid
    page.name = 'имя_страницы?'
    expect(page).to_not be_valid
  end

  it 'can produce path' do
    page = FactoryBot.create(:page, name: 'page')
    expect(page.path).to eq('page')
  end

  it 'can produce nested path' do
    page = FactoryBot.create(:page, name: 'page')
    page2 = FactoryBot.create(:page, name: 'page2', parent_page: page)
    page3 = FactoryBot.create(:page, name: 'page3', parent_page: page2)
    expect(page3.path).to eq('page/page2/page3')
  end

  it 'has hierarchy' do
    page = FactoryBot.create(:page, name: 'page')
    expect(page.hierarchy).not_to be nil
  end

  it 'has nested hierarchy' do
    page = FactoryBot.create(:page, name: 'page')
    page2 = FactoryBot.create(:page, name: 'page2', parent_page: page)
    page3 = FactoryBot.create(:page, name: 'page3', parent_page: page2)
    hierarchy = { name: 'page', path: 'page',
                  pages: [name: 'page2', path: 'page/page2', pages: [name: 'page3', path: 'page/page2/page3', pages: []]] }
    expect(page.hierarchy).to eq(hierarchy)
  end

  it 'produces content out of content_raw' do
    page = FactoryBot.create(:page, content: nil, content_raw: 'content')
    expect(page.content).not_to be nil
  end

  it 'replaces *[content]* with <b>content</b>' do
    page = FactoryBot.create(:page, content_raw: '*[content]*')
    expect(page.content).to eq('<b>content</b>')
  end

  it 'replaces \\\\content\\\\ with <i>content</i>' do
    page = FactoryBot.create(:page, content_raw: '\\\\content\\\\')
    expect(page.content).to eq('<i>content</i>')
  end

  it 'replaces ((name1/name2/name3 content)) with <a href="/name1/name2/name3">content</a>' do
    page = FactoryBot.create(:page, content_raw: '((name1/name2/name3 content))')
    expect(page.content).to eq('<a href="/name1/name2/name3">content</a>')
  end
end
