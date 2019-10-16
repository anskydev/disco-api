defmodule Disco.Mailer do
  @from "register@discow.app"

  use Mailgun.Client,
    domain: Application.get_env(:disco, :mailgun_domain),
    key: Application.get_env(:disco, :mailgun_key)

  def send_verification_email(email_address, name, verification_url) do
    send_email(
      to: email_address,
      from: @from,
      subject: "Welcome to Disco! Please verify your account",
      html:
        Phoenix.View.render_to_string(
          DiscoWeb.RegisterVerificationView,
          "email.html",
          %{
            name: name,
            url: verification_url
          }
        )
    )
  end
end
