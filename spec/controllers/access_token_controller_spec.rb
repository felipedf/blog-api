require 'rails_helper'

RSpec.describe AccessTokenController, type: :controller do
  describe '#create' do
    shared_examples_for 'unauthorized_requests' do
      let(:authentication_error) do
        {
          "status" => "401",
          "source" => { "pointer" => "/code" },
          "title"  =>  "Authentication code is invalid",
          "detail" => "You must provide a valid code in exchange for a token."
        }
      end

      it 'should return 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'should return a proper json body' do
        subject
        expect(json['errors']).to include(authentication_error)
      end
    end

    context 'when no code provided' do
      subject { post :create }
      it_behaves_like 'unauthorized_requests'
    end

    context 'when invalid code provided' do
      let(:github_error) { double("Sawyer::Resource", error: "bad_verification_code") }

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(github_error)
      end

      subject { post :create, params: { code: 'invalid_code' } }
      it_behaves_like 'unauthorized_requests'
    end

    context 'when valid code provided' do
      let(:user_data) do
        {
          login: 'foobar',
          url: 'http://foo.bar',
          avatar_url: 'http://foo.bar/avatar',
          name: 'Foo Bar'
        }
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return({})

        allow_any_instance_of(Octokit::Client).to receive(
          :user).and_return(user_data)
      end

      subject { post :create, params: { code: 'valid_code'} }
      it 'should return 201 status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'should create a user in the database' do
        expect{ subject }.to change{ User.count }.by(1)
      end

      it 'should have a proper json body' do
        subject
        user = User.find_by(login: user_data[:login])
        expect(json_data['attributes']).to eq({ 'token' => user.access_token.token })
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:authorization_error) do
      {
        "status" => "403",
        "source" => { "pointer" => "/headers/authorization" },
        "title"  =>  "Not authorized",
        "detail" => "You have no right to access this resource."
      }
    end

    subject { delete :destroy }

    context 'when access code is valid' do
      it 'should delete the user access_token' do

      end
    end

    context 'when access code is invalid' do
      it 'should return 403 status code' do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it 'should return a proper json body' do
        subject
        expect(json['errors']).to include(authorization_error)
      end
    end
  end
end
