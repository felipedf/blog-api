class AccessTokenController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    token = authenticator.perform
    render json: token, status: :created
  end

  def destroy
    raise AuthorizationError
  end

  private

  def serializer
    AccessTokenSerializer
  end
end
