# frozen_string_literal: true

class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :user

  def initialize(code)
    @code = code
  end

  def perform
    client = Octokit::Client.new(
      client_id: '9d59bdc3e317cb808fac',
      client_secret: 'dae26e7f5542771c4c90cf8247fd2cd241403367'
    )

    token = client.exchange_code_for_token(code)

    raise AuthenticationError if token.try(:error).present?

    user_client = Octokit::Client.new(
      access_token: token
    )

    user_data = user_client.user.to_h
                           .slice(:login, :avatar_url, :url, :name)

    User.create(user_data.merge(provider: 'github'))
  end

  private

  attr_reader :code
end
