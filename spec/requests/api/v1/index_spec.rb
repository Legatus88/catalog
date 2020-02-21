require 'rails_helper'

describe '/index', type: :request do
  let(:password) { '123456' }
  let!(:current_user) { create :user, password: password }
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

  before do
    5.times do
      create :article, user: current_user
    end
  end

  it 'responds with auth error' do
    send(:get, '/api/articles')
    expect(JSON.parse(response.body)['error']).to eq("Not Authorized")
  end

  it 'responds with all articles' do
    send(
      :get, '/api/articles',
      params: {},
      headers: { 'Authorization': "#{get_token}" }
    )

    expect(JSON.parse(response.body).count).to eq(5)
  end
end
