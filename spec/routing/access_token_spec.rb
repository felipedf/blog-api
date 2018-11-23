require 'rails_helper'

describe 'access token routes' do
  it 'should route to access_tokens create action' do
    expect(post '/login').to route_to('access_token#create')
  end

  it 'should route to access_token destroy action' do
    expect(delete '/logout').to route_to('access_token#destroy')
  end
end