require 'rails_helper'

describe '/authenticate', type: :request do
  let(:password) { '123456' }
  let!(:current_user) { create :user, password: password }
  let(:headers) { { 'Content-Type': 'application/json' } }
  let(:params) { {"login": "#{current_user.login}", "password": password} }

  it 'responds with a auth_token' do
    send(
        :post, '/api/authenticate',
        params: params.to_json,
        headers: headers
      )

    expect(JSON.parse(response.body).keys).to eq(['auth_token'])
  end

  it 'responds with error' do
    send(
        :post, '/api/authenticate',
        params: {},
        headers: headers
      )
    expect(JSON.parse(response.body)['error']).to eq({"user_authentication"=>"invalid credentials"})
  end
end
