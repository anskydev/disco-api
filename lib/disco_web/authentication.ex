defmodule DiscoWeb.Authentication do
  @user_salt System.get_env("USER_SALT")

  def sign(data) do
    Phoenix.Token.sign(DiscoWeb.Endpoint, @user_salt, data)
  end

  def verify(token, session_type \\ :login) do
    max_age = if session_type == :register, do: 24 * 3600, else: 30 * 24 * 3600
    Phoenix.Token.verify(DiscoWeb.Endpoint, @user_salt, token, max_age: max_age)
  end
end
