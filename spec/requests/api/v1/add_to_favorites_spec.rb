require 'rails_helper'

describe '/add_to_favorites', type: :request do
  let(:password) { '123456' }
  let!(:current_user) { create :user, password: password }
  let(:article) { create :article, user: current_user }
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
    send(:post, "/api/articles/#{article.id}/add_to_favorites")
    expect(JSON.parse(response.body)['error']).to eq("Not Authorized")
  end

  it 'responds with selected article' do
    send(
      :post, "/api/articles/#{article.id}/add_to_favorites",
      params: {},
      headers: { 'Authorization': "#{get_token}" }
    )
    expect(JSON.parse(response.body)['result']).to eq('Saved to favorites')
  end

  it 'responds with an error' do
    create :favorite, user: current_user, article: article

    send(
      :post, "/api/articles/#{article.id}/add_to_favorites",
      params: {},
      headers: { 'Authorization': "#{get_token}" }
    )

    expect(JSON.parse(response.body)['result']['user_id']).to eq(['has already been taken'])
  end
end
