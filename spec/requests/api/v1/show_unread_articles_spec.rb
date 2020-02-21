require 'rails_helper'

describe '/show_unread_articles', type: :request do
  let(:password) { '123456' }
  let!(:current_user) { create :user, password: password }
  let!(:common_user) { create :user, password: '7890123'}
  let!(:first_article) { create :article, user: current_user }
  let!(:second_article) { create :article, user: common_user }
  let!(:read_article) { create :read_article, article: first_article, user: current_user }
  let(:headers) { { 'Content-Type': 'application/json' } }
  let(:params) { {"login": "#{current_user.login}", "password": password} }

  def get_token
    send(
        :post, '/api/authenticate',
        params: params.to_json,
        headers: headers
      )
    JSON.parse(response.body)['auth_token']
  end

  it 'responds with auth error' do
    send(:get, '/api/show_unread_articles')
    expect(JSON.parse(response.body)['error']).to eq("Not Authorized")
  end

  it 'responds with selected article' do
    send(
      :get, '/api/show_unread_articles',
      params: {},
      headers: { 'Authorization': "#{get_token}" }
    )
    expect(JSON.parse(response.body)).to eq([JSON.parse(second_article.to_json)])
  end
end
