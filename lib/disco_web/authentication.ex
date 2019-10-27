defmodule DiscoWeb.Authentication do
  @user_salt System.get_env("USER_SALT")

  def sign(data, session_type \\ :login) do
    opts = if session_type == :register, do: [key_length: 16], else: []

    Phoenix.Token.sign(DiscoWeb.Endpoint, @user_salt, data, opts)
  end

  def verify(token, session_type \\ :login) do
    opts =
      if session_type == :register do
        [
          key_length: 16,
          max_age: 24 * 3600
        ]
      else
        [
          max_age: 30 * 24 * 3600
        ]
      end

    Phoenix.Token.verify(DiscoWeb.Endpoint, @user_salt, token, opts)
  end
end
