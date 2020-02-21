require 'rails_helper'

describe '/show_favorites', type: :request do
  let(:password) { '123456' }
  let!(:current_user) { create :user, password: password }
  let(:article) { create :article, user: current_user }
  let!(:favorite) { create :favorite, user: current_user, article: article }
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
    send(:get, '/api/favorites')
    expect(JSON.parse(response.body)['error']).to eq("Not Authorized")
  end

  it 'responds with selected article' do
    send(
      :get, '/api/favorites',
      params: {},
      headers: { 'Authorization': "#{get_token}" }
    )
    expect(JSON.parse(response.body)).to eq(JSON.parse(current_user.favorite_articles.to_json))
  end
end
