class ApplicationController < ActionController::API
  include PaginationMetaGenerator
  class AuthorizationError < StandardError; end
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error

  def render(options = {})
    if serializer && ( !options[:json].is_a?(Hash) || options[:json][:errors].nil? )
      options[:json] = serializer.new(*options[:json])
    end
    super(options)
  end

  private

  def authentication_error
    error = {
      status: "401",
      source: { pointer: "/code" },
      title:  "Authentication code is invalid",
      detail: "You must provide a valid code in exchange for a token."
    }
    render json: { errors: [ error ] }, status: 401
  end

  def authorization_error
    error = {
      "status" => "403",
      "source" => { "pointer" => "/headers/authorization" },
      "title"  =>  "Not authorized",
      "detail" => "You have no right to access this resource."
    }
    render json: { errors: [ error ] }, status: 403
  end

  def per_page
    (params[:per_page] || DEFAULT_PER_PAGE).to_i
  end

  def current_page
    (params[:page] || DEFAULT_PAGE).to_i
  end

  def serializer
    # Should be implemented on subclasses
  end
end
