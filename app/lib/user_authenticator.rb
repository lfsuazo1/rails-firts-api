class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :code

  def initialize(code)
    @code = code
  end

  def perform
    client = Octokit::Client.new(
      client_id="9d59bdc3e317cb808fac",
      client_secret="bf241ec8c60e1e349ac62f9edf522528c47d7a49",
    )

    token = client.exchange_code_for_token(code)

    if token.try(:error).present?
      raise AuthenticationError
    else
      #user regirstration
      user_client = Octokit::Client.new(
        access_token: token)
      user_data = user_client.user.to_h.
        slice(:login, :avatar_url, :url, :name)
      User.create(user_data.merge(provider: 'github'))
    end
  end
end
