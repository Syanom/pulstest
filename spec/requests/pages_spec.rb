require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  it 'navigates to pages#show' do
    page = FactoryBot.create(:page, name: 'page_name')
    get '/page_name'
    expect(response).to have_http_status(200)
  end

  it 'does not navigate to not existing page' do
    get '/not_existed_page'
    expect(response).to have_http_status(404)
  end

  it 'supports nested pages hierarchy' do
    page = FactoryBot.create(:page, name: 'page')
    page2 = FactoryBot.create(:page, name: 'page2', parent_page: page)
    FactoryBot.create(:page, name: 'page3', parent_page: page2)
    get '/page/page2/page3'
    expect(response).to have_http_status(200)
  end

  it 'does not navigate to incorrect page route' do
    page = FactoryBot.create(:page, name: 'page')
    page2 = FactoryBot.create(:page, name: 'page2', parent_page: page)
    FactoryBot.create(:page, name: 'page3', parent_page: page2)
    get '/page2/page3'
    expect(response).to have_http_status(404)
  end

  it 'navigates to add page path' do
    page = FactoryBot.create(:page, name: 'page')
    get '/page/add'
    expect(response).to have_http_status(200)
  end

  it 'navigates to add page to root path' do
    get '/add'
    expect(response).to have_http_status(200)
  end

  it 'navigates to edit page path' do
    page = FactoryBot.create(:page, name: 'page')
    get '/page/edit'
    expect(response).to have_http_status(200)
  end
end
